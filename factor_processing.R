# 加载必要的库
library(data.table)
library(lubridate)

# 创建新表格的函数
create_factor_df_new <- function(factor_df) {
  # 复制eid和p200列
  factor_df_new <- factor_df[, .(eid, p200)]
  
  # 获取所有日期列（排除eid和p200）
  date_cols <- names(factor_df)[sapply(factor_df, function(x) class(x)[1] == "IDate")]
  date_cols <- date_cols[date_cols != "p200"]
  
  # 为每一行找到大于p200且最近的日期
  factor_df_new[, date := as.IDate(NA)]
  factor_df_new[, date_gap := NA_real_]
  
  for(i in 1:nrow(factor_df_new)) {
    p200_date <- factor_df_new$p200[i]
    
    if(!is.na(p200_date)) {
      # 获取当前行的所有日期值
      row_dates <- factor_df[i, date_cols, with = FALSE]
      
      # 转换为向量并移除NA值
      valid_dates <- as.vector(unlist(row_dates))
      valid_dates <- valid_dates[!is.na(valid_dates)]
      
      # 找到大于p200的日期
      future_dates <- valid_dates[valid_dates > p200_date]
      
      if(length(future_dates) > 0) {
        # 找到最近的日期
        closest_date <- future_dates[which.min(future_dates - p200_date)]
        factor_df_new$date[i] <- closest_date
        
        # 计算月份差
        months_diff <- interval(p200_date, closest_date) %/% months(1)
        factor_df_new$date_gap[i] <- months_diff
      }
    }
  }
  
  return(factor_df_new)
}

# 使用你的数据创建新表格
factor_df_new <- create_factor_df_new(factor_df)

# 显示结果
print(head(factor_df_new, 10))
