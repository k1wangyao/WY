# 加载必要的库
library(data.table)
library(lubridate)

# 优化的函数，使用data.table的向量化操作
create_factor_df_new_optimized <- function(factor_df) {
  # 复制eid和p200列
  factor_df_new <- factor_df[, .(eid, p200)]
  
  # 获取所有日期列（排除eid和p200）
  date_cols <- names(factor_df)[sapply(factor_df, function(x) class(x)[1] == "IDate")]
  date_cols <- date_cols[date_cols != "p200"]
  
  cat("找到的日期列：", paste(date_cols, collapse = ", "), "\n")
  
  # 使用melt将日期列转换为长格式
  date_data <- melt(factor_df[, c("eid", "p200", date_cols), with = FALSE], 
                    id.vars = c("eid", "p200"), 
                    variable.name = "date_col", 
                    value.name = "date_value")
  
  # 移除NA值
  date_data <- date_data[!is.na(date_value)]
  
  # 找到大于p200的日期
  date_data <- date_data[date_value > p200]
  
  # 按eid分组，找到最近的日期
  result <- date_data[, .(
    date = date_value[which.min(date_value - p200)],
    date_gap = as.numeric(interval(p200[1], date_value[which.min(date_value - p200)]) %/% months(1))
  ), by = eid]
  
  # 合并结果
  factor_df_new <- merge(factor_df_new, result, by = "eid", all.x = TRUE)
  
  return(factor_df_new)
}

# 使用你的数据创建新表格
factor_df_new <- create_factor_df_new_optimized(factor_df)

# 显示结果
cat("新表格前10行：\n")
print(head(factor_df_new, 10))

# 显示统计信息
cat("\n统计信息：\n")
cat("总行数：", nrow(factor_df_new), "\n")
cat("有找到未来日期的行数：", sum(!is.na(factor_df_new$date)), "\n")
cat("没有找到未来日期的行数：", sum(is.na(factor_df_new$date)), "\n")

if(sum(!is.na(factor_df_new$date_gap)) > 0) {
  cat("月份差统计：\n")
  print(summary(factor_df_new$date_gap[!is.na(factor_df_new$date_gap)]))
}
