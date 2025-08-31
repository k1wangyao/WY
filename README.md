# Factor Data Processing

这个R脚本用于处理factor_df数据，创建一个新的表格factor_df_new，包含以下功能：

## 功能说明

1. **保留原始列**：eid和p200列保持不变
2. **新增date列**：从其他日期列中找到大于p200且最近的日期
3. **新增date_gap列**：计算date与p200之间的月份差

## 文件说明

- `factor_processing.R`：基础版本，使用循环处理
- `factor_processing_optimized.R`：优化版本，使用data.table向量化操作

## 使用方法

1. 确保你的数据名为`factor_df`
2. 运行以下命令：

```r
# 加载脚本
source("factor_processing_optimized.R")
```

## 输出结果

新表格`factor_df_new`包含以下列：
- `eid`：原始ID
- `p200`：原始日期
- `date`：找到的最近未来日期
- `date_gap`：月份差（以月为单位）

## 注意事项

- 需要安装`data.table`和`lubridate`包
- 如果某行没有找到大于p200的日期，date和date_gap列将为NA
- 月份差使用lubridate的interval函数计算
