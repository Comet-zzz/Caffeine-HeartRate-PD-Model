library(ggplot2)


cat("\n咖啡因心率效应模型\n")
cat("请选择数据导入方式：\n")
cat("  1. 使用内置模拟数据（立即体验）\n")
cat("  2. 从 CSV 文件读取（推荐，最高效）\n")
cat("  3. 手动输入（备用方案）\n")
cat("······\n")

choice <- readline(prompt = "请输入数字 (1/2/3): ")

if (choice == "1") {
  cat("\n正在加载模拟数据...\n")
  HR_control <- c(72, 71, 73, 72, 78, 74, 75, 73, 72, 74, 73, 71)
  HR_caffeine <- c(72, 76, 80, 84, 86, 87, 85, 83, 80, 78, 76, 74)
  
  #选项 2：从 CSV 读取（最推荐）1
} else if (choice == "2") {
  cat("\n请确保 CSV 文件包含两列数据（无表头）：\n")
  cat("  第1列：对照日心率（12个值）\n")
  cat("  第2列：咖啡日心率（12个值）\n")
  cat("示例格式（保存为 data.csv）：\n")
  cat("72, 72\n71, 76\n73, 80\n...（共12行）\n\n")
  
  cat("请在弹出的窗口中选择你的 CSV 文件...\n")
  file_path <- file.choose()  # 弹出文件选择对话框
  data_import <- read.csv(file_path, header = FALSE)
  
  HR_control <- data_import[, 1]
  HR_caffeine <- data_import[, 2]
  
  cat("数据读取成功！共", length(HR_control), "个观测值。\n")
  
} else if (choice == "3") {
  cat("\n请按顺序输入对照日的12个心率值（用空格分隔）：\n")
  control_input <- readline(prompt = "对照日心率：")
  HR_control <- as.numeric(strsplit(control_input, " ")[[1]])
  
  cat("\n请按顺序输入咖啡日的12个心率值（用空格分隔）：\n")
  caffeine_input <- readline(prompt = "咖啡日心率：")
  HR_caffeine <- as.numeric(strsplit(caffeine_input, " ")[[1]])
  
} else {
  cat("无效选择，请重新运行脚本。\n")
  stop()
}

if (length(HR_control) != 12 || length(HR_caffeine) != 12) {
  cat("\n错误：数据长度不正确！需要12个值。\n")
  stop("请重新运行脚本。")
}

# 5. 构建数据框并分析（后续代码完全一样）-----------------------------
time <- seq(0, 110, by = 10)
caffeine_data <- data.frame(
  time = time,
  HR_control = HR_control,
  HR_caffeine = HR_caffeine
)
caffeine_data$delta_HR <- caffeine_data$HR_caffeine - caffeine_data$HR_control

cat("\n数据预览\n")
print(caffeine_data)

p1 <- ggplot(caffeine_data) +
  geom_line(aes(x = time, y = HR_control, color = "Control")) +
  geom_point(aes(x = time, y = HR_control, color = "Control")) +
  geom_line(aes(x = time, y = HR_caffeine, color = "Caffeine")) +
  geom_point(aes(x = time, y = HR_caffeine, color = "Caffeine")) +
  geom_line(aes(x = time, y = delta_HR, color = "Delta (Net Effect)"), 
            linetype = "dashed", linewidth = 1) +
  geom_point(aes(x = time, y = delta_HR, color = "Delta (Net Effect)")) +
  labs(title = "Caffeine Effect on Heart Rate",
       x = "Time (minutes)", y = "Heart Rate (bpm)") +
  theme_minimal() +
  scale_color_manual(values = c("Control" = "blue", 
                                "Caffeine" = "darkgreen", 
                                "Delta (Net Effect)" = "red"))
print(p1)

# LOESS 平滑
loess_fit <- loess(delta_HR ~ time, data = caffeine_data)
caffeine_data$smoothed_delta <- predict(loess_fit)

p2 <- ggplot(caffeine_data, aes(x = time, y = delta_HR)) +
  geom_point(color = "gray50", linewidth = 2) +
  geom_line(aes(y = smoothed_delta), color = "red", linewidth = 1.2) +
  labs(title = "Smoothed Net Caffeine Effect (LOESS)",
       x = "Time (minutes)", y = "ΔHR (bpm)") +
  theme_minimal()
print(p2)

peak_idx <- which.max(caffeine_data$delta_HR)
Tmax <- caffeine_data$time[peak_idx]
peak_value <- caffeine_data$delta_HR[peak_idx]

n <- nrow(caffeine_data)
auc <- 0
for (i in 2:n) {
  auc <- auc + (caffeine_data$time[i] - caffeine_data$time[i-1]) * 
    (caffeine_data$delta_HR[i] + caffeine_data$delta_HR[i-1]) / 2
}

cat("\n定量结果\n")
cat("Tmax (达峰时间) =", Tmax, "分钟\n")
cat("最大净心率增量 =", peak_value, "bpm\n")
cat("AUC (曲线下面积, 0-110min) =", round(auc, 2), "bpm*min\n")

ggsave("caffeine_curves_raw.png", plot = p1, width = 6, height = 4, dpi = 300)
ggsave("caffeine_curves_smoothed.png", plot = p2, width = 6, height = 4, dpi = 300)

cat("\n图片已保存至工作目录。\n")
cat("分析完成\n")