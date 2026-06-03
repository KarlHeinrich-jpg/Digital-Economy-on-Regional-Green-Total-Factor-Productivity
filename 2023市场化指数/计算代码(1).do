*更多数据请关注公众号【众鲤数据网】官网https://zldatas.com*

* 1.打开文件所在路径
cd //根据自己的情况选定

* 2.计算过程
* 2.1 1997-2019年市场化指数（含分项指数）
import excel 1997-2019年市场化指数和各分项指数.xlsx, firstrow clear
save 1997-2019年市场化指数和各分项指数.dta, replace

* 2.2 1997-2023年市场化指数（含分项指数）
use 1997-2019年市场化指数和各分项指数.dta, clear
keep province  
duplicates drop province  , force  //duplicates剔除重复值，force强制执行
expand 27  //1997-2023年一种27年，将年度数据从1997年开始拓展到2023年
bys province : gen n=_n  //1997-2023年一种27年，将年度数据从1997年开始拓展到2023年
gen year=1996+n  //1997-2023年一种27年，将年度数据从1997年开始拓展到2023年
merge 1:1 province  year using 1997-2019年市场化指数和各分项指数.dta, nogen keepusing(market 政府与市场关系	非国有经济发展	产品市场的发育程度	要素市场的发育程度	市场中介组织的发育和法律制度环境)
egen code=group(province) //用字符型的“province ”生成为数值型的“code”
xtset code year

* 计算年度增长率
foreach i in market 政府与市场关系 非国有经济发展 产品市场的发育程度 要素市场的发育程度 市场中介组织的发育和法律制度环境 {
   gen `i'增长率=`i'/L.`i'-1
}

* 计算历年平均增长率
foreach i in market 政府与市场关系 非国有经济发展 产品市场的发育程度 要素市场的发育程度 市场中介组织的发育和法律制度环境 {
   bys province: egen `i'平均增长率=mean(`i'增长率) 
}

* 计算得到2020、2021、2022和2023年的市场化总指数和各分项指数
xtset code year
foreach i in market 政府与市场关系 非国有经济发展 产品市场的发育程度 要素市场的发育程度 市场中介组织的发育和法律制度环境 {
   replace `i'=L.`i'*(1+`i'平均增长率)  if `i'==. 
}

* 保留到小数点后3位
foreach i in market 政府与市场关系 非国有经济发展 产品市场的发育程度 要素市场的发育程度 市场中介组织的发育和法律制度环境 {
   replace `i'=round(`i',0.001)
}

keep province year market 政府与市场关系 非国有经济发展 产品市场的发育程度 要素市场的发育程度 市场中介组织的发育和法律制度环境
rename province 省份
save 1997-2023年市场化指数和各分项指数.dta, replace
export excel 1997-2023年市场化指数和各分项指数.xlsx, firstrow(var) replace

* 2.3 公司资料
import excel 公司资料.xlsx, firstrow clear

* 剔除最后两行数据
drop if 证券简称==""
	
* 生成从上市年份开始到2023年的数据
gen 上市年份=real(substr(上市日期, 1, 4)) 
expand 2023-上市年份+1  //拓展的年份数为“2023-上市年份+1”
bys 证券代码: gen year=上市年份+_n-1

* 选择年份
keep if year>=1997 & year<=2023
 
* 省份
replace 省份=substr(省份, 1, 6) if !regexm(省份, "内蒙古") & !regexm(省份, "黑龙江")
replace 省份=substr(省份, 1, 9) if regexm(省份, "内蒙古") | regexm(省份, "黑龙江")

* 2.4 匹配数据
merge m:1 省份 year using 1997-2023年市场化指数和各分项指数.dta, nogen keep(1 3)
  
gen code=real(substr(证券代码, 1, 6))
replace 证券代码=substr(证券代码, 1, 6)


* 3.保存并导出计算结果
sort code year
order code 证券代码 year 证券简称 上市日期 上市年份 成立日期 省份 城市 market
save 计算结果.dta, replace
export excel 计算结果.xlsx, firstrow(var) replace



*更多数据请关注公众号【众鲤数据网】官网https://zldatas.com*











