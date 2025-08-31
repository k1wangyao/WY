# 示例：如何使用factor_processing脚本

# 首先安装必要的包（如果还没有安装）
if (!require(data.table)) install.packages("data.table")
if (!require(lubridate)) install.packages("lubridate")

# 加载包
library(data.table)
library(lubridate)

# 创建示例数据（模拟你的真实数据）
set.seed(123)
n <- 100
factor_df <- data.table(
  eid = 1000000 + 1:n,
  p200 = as.IDate(sample(seq(as.Date("2008-01-01"), as.Date("2010-12-31"), by="day"), n)),
  p131270 = as.IDate(sample(seq(as.Date("2008-01-01"), as.Date("2015-12-31"), by="day"), n)),
  p131288 = as.IDate(sample(seq(as.Date("2008-01-01"), as.Date("2015-12-31"), by="day"), n)),
  p131292 = as.IDate(sample(seq(as.Date("2008-01-01"), as.Date("2015-12-31"), by="day"), n)),
  p131296 = sample(c("Yes", "No", ""), n, replace = TRUE),
  p131298 = as.IDate(sample(seq(as.Date("2008-01-01"), as.Date("2015-12-31"), by="day"), n)),
  p131300 = as.IDate(sample(seq(as.Date("2008-01-01"), as.Date("2015-12-31"), by="day"), n))
)

# 添加一些NA值
for(col in c("p131270", "p131288", "p131292", "p131298", "p131300")) {
  factor_df[sample(1:n, n*0.3), (col) := NA]
}

cat("原始数据前6行：\n")
print(head(factor_df))

# 运行处理脚本
source("factor_processing_optimized.R")

cat("\n处理完成！新表格已创建为 factor_df_new\n")
