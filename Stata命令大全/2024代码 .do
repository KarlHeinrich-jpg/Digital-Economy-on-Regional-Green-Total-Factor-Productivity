实证Stata代码命令汇总
更新时间：2024.1
实证Stata代码命令汇总	1
（一） 数据导入和管理	3
1.	数据导入	4
2.	数据导出	4
（二） 数据的处理	4
1.	生成新变量	4
2.	格式转换	4
3.	缺失数据	4
4.	异常数据	5
5.	重命名变量	5
6.	编码分类变量	5
7.	设定面板数据	5
8.	数据合并	5
9.	数据追加	5
10.	国泰安原始数据处理	5
11.	CFPS原始数据处理	8
12.	CHFS原始数据处理	14
13.	字符串截取	19
14.	正则表达提取	20
（三） 描述性统计	21
1.	基本统计	21
2.	变量的详细统计	21
3.	变量的频率表	21
4.	变量间的相关性	21
5.	回归分析及其描述性统计	21
6.	简单统计	21
（四） 相关性分析	21
1.	绘制直方图	21
2.	绘制散点图	21
3.	矩阵散点图	21
4.	相关图	21
5.	回归拟合图	21
6.	相关系数	21
7.	相关系数矩阵	22
（五） 实证模型	22
1.	单变量分析	22
2.	OLS回归	22
3.	分位数回归	22
4.	泊松回归	22
5.	空间Probit模型	23
6.	空间Logit模型	23
7.	空间Tobit模型	23
8.	灰色关联分析法	23
9.	熵值法	25
10.	DEA数据包络分析法（数量分析方法）	27
11.	向量自回归模型（VAR）	27
12.	门槛模型	29
13.	断点回归模型	30
14.	全要素生产率估计	31
15.	合成控制法（SCM）	32
16.	安慰剂检验	33
（六） 内生性解决	33
1.	工具变量法（IV估计）	33
2.	固定效应模型	33
3.	随机效应模型	34
4.	系统GMM模型	34
5.	DID模型	34
6.	PSM模型	36
7.	PSM-DID模型	37
8.	滞后期模型	38
（七） 收敛性分析	39
1.	σ收敛	39
2.	β收敛	39
（八） 检验分析	41
1.	豪斯曼检验	41
2.	Heckman两阶段检验	42
3.	调节效应检验	42
4.	中介效应检验	42
（九） t检验、z检验、卡方检验以及F检验	43
1.	t检验	43
2.	z检验	43
3.	卡方检验	43
4.	F检验	44
（十） 空间计量模型相关命令	44
1.	空间相关性检验（Moran检验）	44
2.	LM检验	44
3.	Hausman检验（固定效应与随机效应检验选择检验）	45
4.	检验地区固定效应、时间固定效应以及双固定效应，三种效应哪个最适合本文的研究	45
5.	LR 检验（用来检验SDM模型能否退化为SEM、SAR模型）	46
6.	WALD检验（也是用来检验模型的适配性）	46
7.	SDM模型回归（空间杜宾模型）	47
8.	SAR模型回归（空间滞后模型）	47
9.	SEM模型回归（空间误差模型）	47
（十一） 结果导出	47
1.	导出描述性统计	47
2.	导出相关系数	47
3.	导出回归结果	48

（一）数据导入和管理
*清除内存中的所有现有数据
clear
*设置工作路径（根据你的文件位置进行调整）
Cd"C:\数据\实证代码命令大全202312版"
1.	数据导入
*从EXCEL文件导入数据
Import excel " example.xlsx " , firstrow
*从CSV文件导入数据
Import delimited " example.csv " , delimiter(" , ")
*从Stata文件(.dta格式)导入数据
use " example.dta " , clear
*检查导入的数据
describe list in 1/5
2.	数据导出
*导出数据到EXCEL文件
export excel using " exported_data.xlsx " , firstrow( variables )
*导出数据到CSV文件
export delimited using " exported_data.xlsx " , delimiter(" , ")
*保存为Stata格式的数据文件
save " export_data.dta " , replace
（二）数据的处理
1.	生成新变量
gen new_var = varl * var2
gen new_var = ln(var)
2.	格式转换
*将字符串日期转换为Stata日期
gen data_var = date(date_string, "DMY")
*年份生成
gen year = real( substr("统计日期", 1, 4))
*字符转为数字格式
destring year, replace
3.	缺失数据
*如果变量var1和var2的任何行存在缺失值，则删除该行
drop if missing(var1) | missing(var2)
*或者通过循环删除变量缺失的数据
foreach i in 变量1 变量2 变量3 { drop in `i' == . }
4.	异常数据
*将var2中不合理的负值设为0
replace var2 = 0 if var2 < 0
*缩尾处理
winspr2 last_income, replace cuts (0 99) //缩尾代替
winspr2 last_income, replace cuts (0 99) trim //缩尾删除
5.	重命名变量
rename var3 new_var3
6.	编码分类变量
*将字符串变量gender转换为数字
encode gender, gen(gender_code)
*生成行业虚拟变量，为了避免共线性，删掉indul
tab Industey, gen(indu)
drop indul
tab year, gen(time)
drop timel
7.	设定面板数据
*假设id和year是面板数据的两个维度
xtest id year
8.	数据合并
*根据id、year合并另一个数据集"raw_data.dta"
merge 1:1 id year using raw_data
9.	数据追加
*追加另一个数据集"extra_data.dta"
append using extra_data
10.	国泰安原始数据处理
（1）批量设定标签
import excel "PT_LCDOMFORAPPLY.xlsx", first clear
labone, nrow(1 2) concat("_")  // 此命令表示将原数据的一二行作为变量标签，并用下划线连接  
drop in 1/2                    // 删除一二行的文字  
destring _all, replace         // 把一些原来被识别为文本类型的变量转换为数值型  
（2）年度变量的转换
gen year = = substr(EndDate, 1, 4)  //从变量EndDate值的第一位开始计数，提取前面四个字符
destring year, replace  //把提取出来的文本变量转换为数值型变量
（3）快速实现表格合并
①	`merge'的横向合并
1)	注意事项
master 表与 using 表均为 dta 格式
变量名称要保持一致
变量类型要保持一致
2)	合并实例
/* 资产负债表 */  
clear  
input long stkcd int year double(asset liability)  
726 2009   6303066959.6 2115429187.87  
726 2010 7015883263.33 2274286167.32  
726 2011 7751885340.43 2281977783.93  
726 2012 8153279084.33 2498587064.52  
726 2013 8411948561.49 1997348584.08  
726 2014 8627671393.88 1611240808.7  
726 2015 9091170499.22 1814572869.22  
726 2016 9407103263.34 1994029422.98  
726 2017 10170624027.75 2395548537.95  
726 2018 10537759811.84 2811935096.45  
end  

/* 利润表 */  
clear  
input long stkcd int year double(revenue netprofit)  
726 2009 4036219837.13 603736257.96  
726 2010 5025624126.3 815053109.96  
726 2011 6078659406.75 892071216.41  
726 2012 5901049894.02 715850368.75  
726 2013 6478245029.16 1039811812.78  
726 2014 6169688792.53 979377181.57  
726 2015 6173322778.61 735543028.77  
726 2016 5981751344.63 853073450.12  
726 2017 6409224044.97   883319109.6  
726 2018 6879058813.93   858193572.1  
end  

use balancesheet.dta, clear  
  
  
merge 1:1 stkcd year using incstatement.dta  
  
  
  Result                           # of obs.  
  -----------------------------------------  
  not matched                             0  
  matched                               646 (_merge==3)  
  -----------------------------------------  
3)	巧用循环实现批量合并
use balancesheet.dta, clear  
foreach v in incstatement shareholders{  
        merge 1:1 stkcd year using `v'.dta  
        drop if _merge != 3  
        drop _merge  
}  
②	`append'的纵向合并
1)	注意事项
保持两表变量名一致
2)	合并实例
forvalues i = 2009/2020{  
        use balancesheet.dta, clear  
        keep if year == `i'  
        save temp_`i'.dta, replace  
}  //把资产负债表当中每一年的数据都拆分出来并分别保存为以 " temp_2009、 temp_2010 ... temp_2010" 命名的 dta 文件

use temp_2009.dta, clear  
        forvalues i = 2010/2020{  
        append using temp_`i'.dta  
}  //得到追加完成样本后的数据，使用save命令进行保存即可
11.	CFPS原始数据处理
（1）提取变量
*以CFPS 2018为例*
use "$cfps2018/cfps2018famecon_202101.dta", clear  
keep fid18 fid16 provcd18 countyid18 cid18 urban18 ///  
       resp1pid fk1l ft200 fincome1_per total_asset familysize18

sum  
  
    Variable |     Obs       Mean    Std. Dev.      Min        Max  
-------------+----------------------------------------------------  
       fid18 |  14,218   401481.9    316756.2    100051    6759191  
       fid16 |  14,218   372239.8    171404.6    100051    2845311  
    provcd18 |  14,217   38.13913    14.95284        11         65  
  countyid18 |  14,199   567.5955    1681.507         1       9992  
       cid18 |  13,122   319687.8    267463.4    100100     999544  
-------------+----------------------------------------------------  
     urban18 |  14,218   .3703756    1.275113        -9          1  
    resp1pid |  14,218   3.85e+08    1.53e+08  1.00e+08   2.49e+09  
        fk1l |  14,218   3.241103    1.985484         1          5  
       ft200 |  14,218   4.726122    1.186591        -8          5  
fincome1_per |  14,218   30592.59    85940.67         0    5660000  
-------------+----------------------------------------------------  
 total_asset |  13,423   775690.7     1842052  -2470000   5.05e+07  
familysize18 |  14,218    3.55901    1.917424         1         21

*查看变量标签*  
label list urban18  
urban18:  
         -10 无法判断  
          -9 缺失  
          -8 不适用  
          -2 拒绝回答  
          -1 不知道  
           0 乡村  
           1 城镇

*缺失值替换为*
for var _all: replace X =. if inlist(X, -10, -9, -8, -2, -1)

*重新赋值*
recode fk1l  (1 = 1 "是")(5 = 0 "否"), gen(agri)  
recode ft200 (1 = 1 "是")(5 = 0 "否"), gen(finp)

*存储家庭变量*
drop fk1l ft200  
  
save "$temp_data/family_2018.dta", replace
（2）跨表合并
*以最常见的家庭库和个人库合并*
*提取个人库变量*
use "$cfps2018/cfps2018person_202012.dta", clear  
keep pid fid18 fid16 provcd18 countyid18 cid18 urban18 gender age ///  
    qa301 qea0 qp605_s_* cfps2018edu   
  
for var _all: replace X =. if inlist(X, -10, -9, -8, -2, -1)

tab qa301  
  
      现在的户口状况 |      Freq.     Percent        Cum.  
-------------------+-----------------------------------  
           农业户口 |     22,585       73.85       73.85  
         非农业户口 |      7,964       26.04       99.89  
           没有户口 |         21        0.07       99.96  
  不适用(非中国国籍) |         12        0.04      100.00  
-------------------+-----------------------------------  
             Total |     30,582      100.00  
  
  
tab qea0  
  
       当前婚姻 |  
          状态 |      Freq.     Percent        Cum.  
---------------+-----------------------------------  
          未婚 |      4,147       13.56       13.56  
  在婚（有配偶） |     23,938       78.25       91.81  
          同居 |        133        0.43       92.24  
          离婚 |        624        2.04       94.28  
          丧偶 |      1,750        5.72      100.00  
---------------+-----------------------------------  
         Total |     30,592      100.00  
  
recode qa301 (1 = 1 "农业户口")(3 = 0 "非农户口")(5 79 =.), gen(hukou)  
recode qea0  (2 3 = 1 "有配偶")(1 4 5 = 0 "无配偶"), gen(spouse)  
recode cfps2018edu      ///  
     (1 = 0 "文盲/半文盲") ///  
     (2 = 1 "小学")        ///  
     (3 = 2 "初中")       ///  
     (4 = 3 "高中")       ///  
     (5 6 7 8 = 4 "大学以以上"), gen(edu)

des qp605_s_*  
  
              storage   display    value  
variable name   type    format     label      variable label  
------------------------------------------------------------  
qp605_s_1       double  %47.0g     qp605_s_1  
                                              医疗保险类型1  
qp605_s_2       double  %47.0g     qp605_s_2  
                                              医疗保险类型2  
qp605_s_3       double  %47.0g     qp605_s_3  
                                              医疗保险类型3  
qp605_s_4       double  %47.0g     qp605_s_4  
                                              医疗保险类型4  
qp605_s_5       double  %47.0g     qp605_s_5  
                                              医疗保险类型5  
  
  
*计算是否有医保及医保数量  *
for var qp605_s_*: replace X =. if X == 78  
gen medsure_dum = 0  
gen medsure_xnh = 0  
gen medsure_num = 0  
  
for var qp605_s_*: replace medsure_dum = 1 if X !=.  
for var qp605_s_*: replace medsure_xnh = 1 if X == 5  
for var qp605_s_*: replace medsure_num = medsure_num + 1 if X !=.

*删除冗余变量*
drop qa301 qea0 qp605_s_* cfps2018edu  
  
save "$temp_data/person_2018.dta", replace

*跨表合并*
        //个人库merge家庭库  
use "$temp_data/person_2018.dta", clear  
  
merge m:1 fid18 using "$temp_data/family_2018.dta", ///  
        keepusing(fincome1_per total_asset familysize18 agri finp) ///  
        keep(1 3) nogen  
     
  
    Result                           # of obs.  
    -----------------------------------------  
    not matched                           619  
        from master                       619    
        from using                          0    
  
    matched                            36,735    
-----------------------------------------

label var medsure_dum "是否购买医保"  
label var medsure_xnh "是否购买新农合"  
label var medsure_num "购买医保数量"  
  
rename (provcd18 countyid18 cid18 urban18 familysize18) ///  
        (provcd countyid cid urban familysize)  
          
save "$temp_data/person2family2018.dta", replace

*家庭库merge个人库*
use "$temp_data/family_2018.dta", clear  
  
rename resp1pid pid  
  
merge 1:1 fid18 pid using "$temp_data/person_2018.dta", ///  
        keepusing(gender-medsure_num) keep(1 3) nogen  
  
  
    Result                           # of obs.  
    -----------------------------------------  
    not matched                           715  
        from master                       715    
        from using                          0    
  
    matched                            13,503    
    -----------------------------------------

label var medsure_dum "是否购买医保"  
label var medsure_xnh "是否购买新农合"  
label var medsure_num "购买医保数量"  
  
rename (provcd18 countyid18 cid18 urban18 familysize18) ///  
        (provcd countyid cid urban familysize)  
          
save "$temp_data/family2person2018.dta", replace
（3）数据核查
*数据核查*
use "$temp_data/family2person2018.dta", clear  
  //查看变量缺失情况  
egen miss = rowmiss(urban fincome1_per total_asset familysize agri finp gender age)  
  
tab miss  
  
       miss |      Freq.     Percent        Cum.  
------------+-----------------------------------  
          0 |     12,600       88.62       88.62  
          1 |        875        6.15       94.77  
          2 |        613        4.31       99.09  
          3 |        121        0.85       99.94  
          4 |          9        0.06      100.00  
------------+-----------------------------------  
      Total |     14,218      100.00

*保留16-85岁的样本*
keep if inrange(age, 16, 85)  
save "$working_data/result_cfps2018.dta", replace
12.	CHFS原始数据处理
（1）数据导入
*导入原始数据*
set matsize 5000
set more off
use '$raw_data\CHFS数据-2015\2015年中国家庭金融调查数据dta格式-stata14以上版本\chfs2015_hh_20191120_version14.dta', clear
（2）数据浏览及变量定义
describe              //描述所有数据
browse                //浏览数据
edit                  //编辑数据
preserve              //与 restore 一起使用可以恢复数据
drop _all             //删除所有数据
restore

preserve 
rename _all, upper    //所有变量大写
rename _all, lower    //所有变量小写
rename _all, proper   //所有变量名首字母大写
rename * *_2021       //所有变量名后加相同后缀前缀
rename (*_2021 ) (havefun_*)  //批量修改变量名的前后缀
restore

gen family_size=a2000a+a2000b
(21,791 missing values generated)

label var family_size '家庭规模' //为变量增加标签

sort family_size           //对数据进行排序

order hhid family_size     //对变量进行排序
（3）删除生成及替代变量
duplicates list hhid       //查询有无重复家户
Duplicates in terms of hhid
(0 observations are duplicates)

duplicates drop hhid,force  //删除重复家户
Duplicates in terms of hhid
(0 observations are duplicates)

encode hhid, gen(newhhid) //变量格式转换

gen nor=1 if d1101==1 | d2101==1
(10,682 missing values generated)

recode nor(1=1)(.=0),gen(no_risk) //变量值替换并产生新变量，无风险资产
(10682 differences between nor and no_risk)

recode a4011c (1=5)(2=4)(3=3)(4=2)(5=1),gen(happiness) //产生幸福感变量
(25272 differences between a4011c and happiness)
recode c1001 (1=1)(2=2)(3=2) ,gen(hous)
(772 differences between c1001 and hous)

gen nf=c7001+hous
(29 missing values generated)

recode nf(2/3=1)(4=0),gen(no_fin) //非金融资产
(21720 differences between nf and no_fin)

recode hous (1=1)(2=0) ,gen(house) //房产
(2602 differences between hous and house)

recode c7001(1=1)(2=0),gen(car) //汽车
(16931 differences between c7001 and car)

gen year=2015                           //产生新变量，生成年份 

egen incomemedian=median(total_income)  //产生新变量，去年总收入的中位数

egen incomemax=max(total_income)        //产生新变量，去年总收入的最大值

replace incomemax=incomemax/10          //把 incomemax 的值缩小 10 倍
(37,243 real changes made)

bys happiness: egen mean_tolincome=mean(total_income) //分组求平均

bys happiness: egen newvar=sum(total_income) //计算分组后的累计和

bys happiness year: egen maxvar=max(total_income) //计算分组后求最大或最小值

drop if happiness==. | happiness==.d | happiness==.r     //删除无效值
(46 observations deleted)

drop if track==0                                        //保留追访家户
(15,494 observations deleted)

keep if  track!=0                                       //保留追访家户
(0 observations deleted)

keep hhid  family_size   year  happiness total_income   //保留需要研究的变量

save $working_data\chfs_2015_hh.dta, replace            //保存数据
file E:\CHFS\Working_data\chfs_2015_hh.dta saved
（4）数据文件的合并
*相同变量数据文件合并，即跨年的面板数据合并*
use $raw_data\CHFS数据-2017\CHFS2017年调查数据-stata14版本\chfs2017_hh_202104.dta, clear

rename a1111 family_size

ren b2003b total_income

recode h3514 (1=5)(2=4)(3=3)(4=2)(5=1),gen(happiness) //产生幸福感变量
(30010 differences between h3514 and happiness)

gen year=2017

keep hhid family_size year total_income happiness //保留需要研究的变量

append using $working_data\chfs_2015_hh.dta //使用 append 让相同变量数据文件合并
(note: variable family_size was byte, now float to accommodate using data's values)
(note: variable total_income was long, now double to accommodate using data's values)

save $working_data\chfs_2015_2017_hh.dta, replace //保存数据
file E:\CHFS\Working_data\chfs_2015_2017_hh.dta saved

*在原数据中加入新变量合并*
*导入原始数据* 
use $raw_data\CHFS数据-2015\2015年中国家庭金融调查数据dta格式-stata14以上版本\chfs2015_master_city_20180504_version14, clear 

*加入新变量合并数据*
merge m:1 hhid using $working_data\chfs_2015_hh.dta  //合并hh数据和master数据

    Result                           # of obs.
    -----------------------------------------
    not matched                        15,540
        from master                    15,540  (_merge==1)
        from using                          0  (_merge==2)

    matched                            21,749  (_merge==3)
    -----------------------------------------

keep if _merge==3            //保留匹配后所需数据
(15,540 observations deleted)

drop _merge                  //需删除，若后续再次匹配则还会生成该变量

save $working_data\chfs_hh_master_2015_hh.dta, replace  //保存数据
file E:\CHFS\Working_data\chfs_hh_master_2015_hh.dta saved
13.	字符串截取
*数据示例*
Accper           Nnindcd        Stkcd
1991-12-31        J66          600371.SH
1992-12-31        K70          600372.SH
1993-06-30        S90          600373.SH
1993-12-31        C27          600374.SH

*导入数据*
use "数据.dta",clear

*不是字符串变量，先转换；是的话跳过此步*
tostring 变量名,replace

*substr命令,substr(变量名，第几位开始截取，第几位结束截取)*
gen year = substr(Accper,1,4)
gen ind = substr(Nnindcd,1,1)
gen stkcd = substr(Stkcd,1,6)

*截取后数据示例*
year               ind          stkcd
1991                J           600371
1992                K           600372
1993                S           600373
1993                C           600374
14.	正则表达提取
*数据示例*
Place
广东省深圳市
四川省成都市
辽宁省大连市庄河市

*导入数据*
use "数据.dta",clear

*正则表达提取*
*0代表提取全部*
gen province=ustrregexs(0) if ustrregexm(
Place,".*省|.*自治区|.*市|.*特别行政区")
*2代表提取第2个括号里的内容，即？后的内容*
gen city1=ustrregexs(2) if ustrregexm(
Place,"(.*省|.*自治区|.*特别行政区)?(.*市|.*自治州|.*地区|.*盟)")
*2代表提取第2个括号里的内容，即？后的内容*
gen city2=ustrregexs(2) if ustrregexm(
city1,"(.*市|.*自治州|.*地区|.*盟)?(.*市)")

*提取后数据示例*
province      city1      city2
广东省        深圳市
四川省        成都市
辽宁省        大连市     庄河市
*（三）描述性统计
*1.	基本统计
summarize     // 或者sum
*2.	变量的详细统计
summarize income, detail
*3.	变量的频率表
tabulate gender
*4.	变量间的相关性
correlate income education
*5.	回归分析及其描述性统计
regress income education age
estat summarize
*6.	简单统计
tabstat y x1 x2 x3, stat(max min mean p50 sd n)
这段Stata代码执行了一个tabstat命令，用于计算变量y、x1、x2和x3的统计量，并指定了要计算的统计量类型为最大值（max）、最小值（min）、平均值（mean）、中位数（p50，即50th percentile）、标准差（sd）和观测数（n）。

*（四）相关性分析
*1.	绘制直方图
histogram income
*2.	绘制散点图
scatter income education
*3.	矩阵散点图
graph matrix var1 var2 var3
*4.	相关图
pwcorr var1 var2 var3, sig star(0.05) matrix(corr_matrix)
matrix plot corr_matrix
*5.	回归拟合图
twoway (scatter var1 var2) (lfit var1 var2)
*6.	相关系数
法1：pwcorr vername 
pwcorr vername, sig//看相关性是否显著
法2：pwcorr_a varname
其中pwcorr是命令，varname是分析变量，pwcorr命令需要下载。
使用pwcorr_a可以输出带*的相关性系数，*表示显著性水平，需要安装
*7.	相关系数矩阵
graph matrix price wei len
（五）实证模型
1.	单变量分析
用途：分析单个变量的基本统计特性，如均值、中位数、方差等，以获取对数据的基本理解
例子：在研究家庭收入时，单变量分析可以用来计算整个样本的平均家庭收入。
*安装ttable3命令：解释变量虚拟形式为01虚拟变量形式
logout, save(单变量分析) word replace:ttable3 被解释变量, by(解释变量虚拟形式) f(%8.4f) notice
2.	OLS回归
用途：分析一个或多个自变量如何线性影响因变量
例子：研究教育水平（自变量）如何个人收入（因变量）
reg y x x1 x2 x3
*导出结果
reg 被解释变量 解释变量 控制变量1 控制变量2 i.year i.industry
est store reg1
esttab reg1 using 主变量回归结果.rtf, replace nogap ar2 b(%6.4f) t(%6.4f) star(* 0.1 ** 0.05 *** 0.01)
3.	分位数回归
用途：分析自变量对因变量不同分位数的影响，提供比OLS更全面的视角。
例子：研究培训项目（自变量）对员工工资（因变量）在不同工资水平（如中位数、上四分位数）的影响。
*分位数为0.1 0.25 0.5 0.75 0.9，可根据研究问题自行调整
sqreg y x1 x2 x3, q( .1 .25 .5 .75 .9)
4.	泊松回归
用途：Poisson回归是一种广义线性模型，用于分析非负整数型的因变量与自变量之间的关系。
例子：分析罕见疾病的发病率与年龄、性别、遗传、环境等因素的关系。
Stata提供了两种命令来实现Poisson回归，分别是`poisson`和`glm`。这两种命令的基本语法如下：
poisson 因变量 [自变量] [，选择项]
glm 因变量 [自变量] [，分布型选择项 联接函数选择项 其他选择项]
其中，`poisson`命令是专门用于拟合Poisson回归模型的，而`glm`命令是用于拟合各种广义线性模型的，可以通过指定`family(poisson)`和`link(log)`来实现Poisson回归。这两种命令的结果是一致的，但是`poisson`命令更简洁，而`glm`命令更灵活。
控制暴露变量（exposure variable），也就是影响因变量发生次数的时间、空间或其他因素，可以使用`offset`或`exposure`选项来指定。`offset`选项要求暴露变量的对数形式，而`exposure`选项要求暴露变量的原始形式。例如，如果数据中有一个变量`pyears`表示每个观测对象的观察年数，可以使用以下命令来控制暴露变量：
poisson 因变量 [自变量]，exposure(pyears)
poisson 因变量 [自变量]，offset(lnpyears)
glm 因变量 [自变量]，family(poisson) link(log) exposure(pyears)
glm 因变量 [自变量]，family(poisson) link(log) offset(lnpyears)
其中，`lnpyears`是`pyears`的对数形式，可以用`gen lnpyears = log(pyears)`来生成。
查看拟合结果的系数、标准误、置信区间、似然比检验等统计量，可以直接输入`poisson`或`glm`命令后回车。查看拟合结果的指数形式，也就是发生率比（incidence rate ratio），可以在命令中加入`irr`选项，或者在拟合后输入`estimates table, eform`命令。
5.	空间Probit模型
用途：分析自变量如何影响二元因变量的概率（发生与不发生），基于正态分布。
例子：分析个人的某些特征（如年龄、教育水平）如何影响其是否选择退休（二元因变量：退休/不退休）
*y为虚拟变量01
probit y x x1 x2 x3
6.	空间Logit模型
用途：与Probit模型类似，但基于逻辑分布，用于分析自变量对二元因变量的影响。
例子：研究信用评分（自变量）如何影响个人获得贷款的概率（二元因变量：批准/未批准）。
*y为虚拟变量01
logit y x x1 x2 x3
7.	空间Tobit模型
用途：处理因变量受限的情况（如有下线或上限），常见于存在截断或下限数据。
例子：研究广告支出（自变量）如何影响产品销售（因变量），当部分产品销售为0（即数据被截断与0）时。
xttobit y x x1 x2 x3 , ll(0) nolog tobit
8.	灰色关联分析法
用途：是一种用于多指标决策评价的方法，由灰色系统理论发展而来。它用于分析和评价多个指标之间的相关性和影响程度，帮助决策者进行综合评价和决策。
例子：通过对某健将级女子铅球运动员的跟踪调查，获得其 1982年至1986年每年最好成绩及16项专项素质和身体素质的时间序列资料，试对此铅球运动员的专项成绩进行因素分析。
use data.dta, clear
* 序列个数(根据数据设计)
global num=3
* 初始值化
* 初值化是指所有数据均用第1个数据除，然后得到一个新的数列
forv i=0/$num {
	qui sum x`i' if _n==1
	gen y`i'=x`i'/r(mean)
}
* 求差序列
forv i=1/$num {
	gen d`i'=abs(y`i'-y0)
}
* 求两级最小差与最大差
forv i=1/$num {
	egen min`i'=min(d`i')
}
forv i=1/$num {
	egen max`i'=max(d`i')
}
egen min_min=rowmin(min1-min$num) 
egen max_max=rowmax(max1-max$num) 
sum min_min
global min_min=r(mean)
sum max_max
global max_max=r(mean)
* 将数据代入关联系数
forv i=1/$num {
	gen e`i'=($min_min + 0.5*$max_max) /(d`i'+0.5*$max_max ) 
}
* 计算关联度
forv i=1/$num {
	egen r`i'=mean(e`i')
	qui sum r`i'
	di "x`i'和x0的关联度为：" r(mean) 
}
9.	熵值法
用途：熵值法是一种依据各指标值所包含的信息量的多少确定指标权重的客观赋权法，某个指标的熵越小，说明该指标值的变异程度越大，提供的信息量也就越多，在综合评价中起的作用越大，则该指标的权重也应越大。
例子：运用熵值法综合评价2022年四川省各市州城市建设环境，选取指标为城市燃气普及率、城市用水普及率、人均城市道路面积、每万人拥有公共交通车辆、人均公园绿地面积、生活垃圾无害化处理率。
import excel "数据.xlsx", firstrow clear
save data.dta, replace
*=========================== 需要设置 =========================== 
//正向指标
global positive_var x1 x2 x3
//负向指标
global negative_var x4 x5
*================================================================ 
*========================= 后面无需改动 ========================= 
//所有指标
global all_var $positive_var $negative_var
//年份
qui sum year
global min_year=r(min)
global max_year=r(max)
forvalues year=$min_year / $max_year{
	use data.dta, clear
	keep if year==`year'
	//将数据标准化处理 -正向指标
	foreach i in $positive_var {
		qui sum `i'
		gen x_`i'=(`i'-r(min))/(r(max)-r(min))
		replace x_`i'=0.00001 if x_`i'==0
	}
	//将数据标准化处理 -负向指标
	foreach i in $negative_var {
		qui sum `i'
		gen x_`i'=(r(max)-`i')/(r(max)-r(min))
		replace x_`i'=0.00001 if x_`i'==0
	}
	//计算指标比重
	foreach i in $all_var {
		egen `i'_sum=sum(x_`i')
		gen y_`i'=x_`i'/`i'_sum
	}
	//根据比重计算各分量的信息熵
	gen n=_N
	foreach i in $all_var {
		gen y_lny_`i'=y_`i'*ln(y_`i')
	}
	//求和
	foreach i in $all_var {
		egen y_lny_`i'_sum=sum(y_lny_`i')
	}
	//计算各指标的贡献总量
	foreach i in $all_var {
		gen E_`i'= -1/ln(n)*y_lny_`i'_sum
	}
	//计算各指标的权重
	foreach i in $all_var {
		gen d_`i'= 1-E_`i'
	}
	egen d_sum = rowtotal(d_*)
	foreach i in $all_var {
		gen W_`i'= d_`i'/d_sum
	}
	//计算最后综合得分
	foreach i in $all_var {
		gen Score_`i'= x_`i'*W_`i'
	}
	egen Score=rowtotal(Score_*)
	keep id year $all_var Score
	save data_`year', replace
}
clear
forvalues i= $min_year / $max_year {
   append using data_`i'
   rm data_`i'.dta
}
10.	DEA数据包络分析法（数量分析方法）
用途：通过明确地考虑多种投入（即资源）的运用和多种产出（及服务）的产生，它能够用来比较提供相似服务的多个服务单位之间的效率，它一般用来测量一些决策部门的生产效率。
例子：企业管理者能运用DEA来比较一组服务单位，识别相对无效率单位，衡量无效率的严重性，并通过对无效率和有效率单位的比较，发现降低无效率的方法。
ssc install dea, replace//下载最新版的dea命令
dea area employee = sales profit
11.	向量自回归模型（VAR）
用途：适用于分析和预测时间序列数据。是一种经济学和统计学中常见的模型，用于研究变量之间的动态关系，特别实在宏观经济学和金融领域。
例子：1）宏观经济分析：var模型可以用于解释宏观经济变量之间的关系，如GDP、通货膨胀、失业率等。通过估计var模型的参数，可以分析这些变量之间的动态关系，并预测宏观经济变量的未来走势。2）货币政策评估：var模型可以用于评估货币政策措施对经济的影响。通过将货币政策变量（如利率）与宏观经济变量进行建模，可以估计出货币政策对于通货膨胀、经济增长等指标的影响效果，并帮助决策者制定合适的货币政策。3）金融市场分析：var模型可以应用于金融市场的风险管理和预测。通过将金融市场相关变量（如股价、汇率、利率等）进行建模，可以分析这些变量之间的相互影响和冲击传播效应，帮助投资者和机构在投资决策和风险管理方面做出更准确的判断。4）资产组合优化：var模型可以用于资产组合的风险评估和优化。通过建立var模型来估计不同资产之间的相关性和波动率，可以帮助投资者构建更有效的资产组合，降低投资组合的风险。
*step1：序列平稳性检验*
help q_time //用stata自带的时间序列数据，选择"lutkepohl2,dta"
tsset qtr //设定时间变量，用stata自带的时间序列数据可不要这步
tsline inv inc consump //画出三个变量的时序图
*单位根检验*
dfuller dln_inv
dfuller dln_inc
dfuller dln_consump
*在x=80（1979q4）的时候，画出一条垂直线。（这个80的地方可以自己任意取，主要把数据分为两个节点，前面一部分作为样本内，进行建模分析，后面一部分用来进行"样本外预测"）*
tsline dln_inv dln_inc dln_consump,xline(80)
sum dln_inv dln_inc dln_consump if _n<=80 //得出1979q4之前的统计指标
sum dln_inv dln_inc dln_consump if _n>80 //得出1979q4之后的统计指标
*step2：确定滞后阶数（根据信息准则）
varsoc dln_inv dln_inc dln_consump if _n<=80,maxlag(13) //计算不同滞后期的信息准则，这里设定最大滞后期为13期
*确定阶数后，估计VAR，再进行残差序列的白噪声检验*
var dln_inv dln_inc dln_consump if _n<=80,lags(1/4)
*如果是小样本的话，用：*
var x y z,lags(1/#) dfk small exog(w1 w2)
*对各阶系数的联合显著性进行检验*
varwle
*检验残差是否为白噪声，即残差序列是否存在自相关*
varlmar
*step3：VAR系统平稳性检验*
varstable,graph
*VAR模型的用途之一是预测。下面预测未来15个季度的变量取值。（如果不想预测，不要这步也可以）*
fcast compute p_,step(15) //"p_"是变量的前缀，可以自己任意定义
fcast graph p_dln_inv p_dln_inc p_dln_consump,observed lpattern("_")
*选择项"observed"表示显示变量的实际观测值，选择项"lpattern("_")"表示以虚线来表示变量的预测值（以区别与实际观测值）
*如果我们预测情况和实际不符，就应该查查开始不准的那个时期发生了什么金融事件或其他事情，进行解释。如果预测不准，我们可以通过检验VAR模型的残差是否服从正态分布进行解释。*
varnorm //估计VAR后，检验残差是否服从正态分布
*step4：格兰杰因果关系检验*
*除了预测外，我们还想知道某个变量的冲击会对该变量或其他变量产生怎样的动态影响，比如提高变量A一个单位会对一年后的变量B产生多大的影响，这就需要用到正交化的脉冲响应函数，但正交化的脉冲响应函数依赖于变量的排序。（上文的预测不依赖于变量排序）。为此，分别考察变量之间的格兰杰因果关系与交叉相关图。*
*考察这三个变量之间的格兰杰因果关系*
vargranger//格兰杰因果关系检验：是一种假设检定的方法，检验一组时间序列x是否为另一种时间序列的原因（时间序列A是否对时间序列B有预测作用）
12.	门槛模型
用途：门槛效应是指当一个经济参数达到特定的数值后，引起另外一个经济参数发生突然转向其他发展形式的现象（结构突变），作为转变的临界值就称为门槛值或者门限值。hansen（1999）首次介绍了具有个体效应的面板门槛模型的计量分析方法。该方法以残差平方和最小化为条件确定门槛值，并检验门槛值的显著性。
例子：如果你认为投资策略在某个未知日期发生了变化，那么可以拟合一个模型来获得该日期的估计，并获得该日期前后不同系数的估计。
xtthres y x ,thres(q) dthres(z) min(#) bs1(#) bs2(#) bs3(#)
***其中y为被解释变量；x为解释变量（不受门槛变量影响的变量）；thres(q) q为门槛变量；
dthres（z）z为受到门槛变量影响的解释变量；min（#）指定在搜索每个区域中的最小观测数，默认值为10；
 bs1(#) bs2(#) bs3(#)分别在单阈值、双阈值和三阈值模型中自抽样次数，默认值都是300.
13.	断点回归模型
用途：断点回归是一种特殊的回归方法，其基本思想是在模型中引入一个断点，以区分自变量对因变量的不同影响。这种断点的引入可以基于数据的特点或者实际问题的需要。在断点回归中，自变量对因变量的影响可以分为两部分：一部分是在断点之前的线性或非线性影响，另一部分是在断点之后的线性或非线性影响。通过估计这两部分的系数，可以得出自变量对因变量的总影响。
例子：Thistlewaite and Campbell(1960)使用断点回归研究奖学金对于未来学业成就的影响。由于奖学金由学习成绩决定，故成绩刚好达到获奖标准与差一点达到的学生具有可比性。
*step1：导入数据*
*使用David S.Lee（2007）参议院选举的数据*
use rdrobust_senate.dta
edit
desc
*step2：绘图查看是否存在断点*
use "rdrobust_senate.dta", clear  
rdplot  vote margin
*step3：进行回归分析*
use "rdrobust_senate.dta", clear  
rdrobust vote margin
rdrobust vote margin, h(15)
*step4：稳健性检验之检验结果对不同带宽、不同多项式次数的稳健性*
rdrobust vote margin   
rdrobust vote margin,all //汇报三种结果
*step5：稳健性检验之带宽选择*
rdbwselect vote margin,all  //CCT IK CV
*step6：稳健性检验之内生分组检验*
DCdensity margin,breakpoint(0) generate(Xj Yj r0 fhat se_fhat)
14.	全要素生产率估计
*全要素生产率估计的stata操作*
prodest depvar [if] [in], method(options)  \\\depvar表示被解释变量，这里应该是产出的对数形式；method表示选择的估计方法
         free(varlist) proxy(varlist) state(varlist)  \\\free表示自由变量；proxy表示代理变量；state表示状态变量

[options]如下表所示：
method选项	含义
op	OP法，Olley and Pakes（OP 1996）
lp	LP法，Levinsohn and Petrin（LP 2003）
wrdg	Wooldridge（2009）提出的方法
rob	Robinson（1998）and Wooldridge（2009）提出的方法
mr	Mpllisi and Rovigatti（MrEst 2017）提出的方法

*全要素生产率估计的实例演示*
// LP method
prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded  id(id) t(year) reps(50)
predict lp, resid

//LP method with ACF correction
prodest log_y, method(lp) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded acf id(id) t(year) reps(50)
predict lpacf, resid

//OP method
prodest log_y, method(op) free(log_lab1 log_lab2) proxy(log_investment) state(log_k) valueadded id(id) t(year) reps(40) poly(4)
predict op, resid

//OP method with ACF correction
prodest log_y, method(op) free(log_lab1 log_lab2) proxy(log_investment) state(log_k) valueadded acf optimizer(nm) id(id) t(year) reps(50)  
predict opacf, resid

//WRDG method
prodest log_y, method(wrdg) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded id(id) t(year) poly(2)
predict WRDG, resid

//MrEst method
prodest log_y, method(mr) free(log_lab1 log_lab2) proxy(log_materials) state(log_k) valueadded lags(1) id(id) t(year) poly(2)
predict MrEst, resid
15.	合成控制法（SCM）
用途：合成控制法（SCM）是一种用于评估政策或事件效应的计量经济学模型，它可以在只有一个处理对象和多个潜在控制对象的情况下，通过对控制对象进行加权平均，构造一个合成的控制对象，作为处理对象的反事实对照，从而估计处理效应。合成控制法的优点是，它可以根据数据驱动的方式确定最优的权重，避免了主观选择控制对象的随意性和内生性问题，提高了结果的透明度和可信度³。合成控制法的缺点是，它需要有足够长的预处理期和后处理期的面板数据，且对结果变量的平稳性和共同趋势假设有较高的要求。
例子：Acemoglu et al. (2019) 用合成控制法评估了土耳其总统 Erdogan 的崛起对土耳其的民主化和经济发展的影响。
*安装synth命令*
ssc install synth, replace
*synth命令的基本语法格式*
synth depvar predictorvars (x1 x2 x3) , trunit (#) trperiod (#) ///  [ counit (numlist) xperiod (numlist) mspeperiod () ///  resultsperiod () nested allopt unitnames (varname) ///  figure keep (file) customV (numlist) optsettings ]
*其中，depvar 是结果变量，predictorvars 是预测变量，trunit 是处理对象的编号，trperiod 是政策干预开始的时期，其他选项可以根据需要进行调整。*
16.	安慰剂检验
用途：安慰剂检验是一种检验政策或干预效果的方法，它通过虚构一个不受政策或干预影响的处理组或时间点，来模拟没有政策或干预的情况，然后与真实的处理组或时间点进行比较，看是否能得到相同的结果。如果能，说明政策或干预没有效果；如果不能，说明政策或干预有效果。安慰剂检验的目的是排除其他可能影响结果的因素，增强估计结果的稳健性。
例子：谌仁俊等（2019）在研究中央环保督察对企业绩效的影响时，使用了一种安慰剂检验：剔除了样本内属于去产能重点行业的企业³。
要用STATA完成安慰剂检验，可以使用permute命令，它可以对指定的变量进行随机抽样，并提取指定的统计量。permute命令的基本语法如下：
permute permvar exp_list [, options] : command
其中，permvar是需要进行随机抽样的变量，比如DID中的处理组虚拟变量或交互项；exp_list是需要提取的统计量，比如回归系数；options是一些选项，比如抽样次数、抽样种子、分层抽样等；command是回归命令，比如reghdfe、xtreg等。
（六）内生性解决
1.	工具变量法（IV估计）
用途：用于解决内生性问题，即当解释变量和误差项相关时。工具变量是与因变量无关但与内生解释变量相关的变量。
例子：研究教育对收入的影响是，教育年数可能与个人能力相关（内生性）。使用某些与个人能力无关但影响教育年数的变量（如地区教育政策）作为工具变量。
*两阶段最小二乘法：y是被解释变量，x1 x2 是内生变量，z1 z2是工具变量，w是控制变量。
ivregress 2sls y w (x1 x2 c.x1#c.x2 = z1 z2 c.z1#c.z2)
2.	固定效应模型
用途：用于控制不随时间变化但可能影响因变量的未观测变量。
例子：分析公司政策对员工生产力的影响，固定效应模型可以控制每个公司的特定特征（如公司文化）。
*设为面板数据
xtext id year
*固定效应模型
streg y x x1 x2 x3, fe
est store reg1
3.	随机效应模型
用途：当个体效应（如个体、公司）被认为是随机且与其他解释变量无关时使用。
例子：在分析多个国家的经济增长数据时，每个国家的特定效应可能被视为随机。
*随机效应模型
xtreg y x x1 x2 x3, re
est store reg2
*导出回归结果
xtreg 被解释变量 var1 var2 var3 i.year i.industry, fe
est store reg2
esttab reg1 reg2 using 回归结果.rtf, replace b(%6.4f) t(%6.4f) nogap
ar2 star(* 0.1 ** 0.05 *** 0.01)
4.	系统GMM模型
用途：用于处理动态面编数据模型中的同时方程偏差和未观测变量偏差。
例子：研究企业投资行为对其未来收益的影响时，系统GMM可以有效控制内生性问题。
xtabond2 y L.y x x1 x2 x3, iv(x1 x2 x3) gmm(L.y L.(x), lag(1 2) c)
robust twostep
5.	DID模型
用途：评估某项政策或事件对处理组和对照组之间影响的差异。
例子：评估"宽带中国"政策对受影响城市（处理组）和未受影响城市（对照组）创新水平的影响。
*post为实验组，若是则取值为1，否则为0；after为是否政策实施前后变量，若政策前则取值为0，若政策后取值为1。c.post#c.after为交乘项，根据ID进行聚类
xtreg被解释变量 c.post#c.after控制变量，fe cluster(id)
est store ml
esttab ml using DID模型.rtf, replace ar2 b(%6.4f) t(%6.4f) star(* 0.1 ** 0.05 *** 0.01)
**DID方法需要满足的五个条件检验
**1.共同趋势假设检验
tab year, gen(yrdum) //产生year dummy，即每一年一个dummy变量
     forval v=1/7{
gen treated`v'=yrdum`v'*treated
}                     //这个相当于产生了政策实行前的那些年份与处理虚拟变量的交互项
xtreg ln_w did treated*  i.year ,fe  //这个没有加控制变量
xtreg ln_w did treated* $xlist i.year ,fe //如果did依然显著，且treated*这些政策施行前年份交互项并不显著，那就好
xtreg ln_w did treated* $xlist i.year if union!=1 ,fe //我们认为工会会影响这个处理组和控制组的共同趋势，因此我们看看union=0的情形

**2.政策干预时间的随机性
gen time1 = (year >= 75) & !missing(year)  //政策执行时间提前到1975年
gen treated1= (idcode >2000)&!missing(idcode) //政策执行地方为idcode大于2000的地方
gen did1 = time1*treated1  //这就是需要估计的DID，也就所交叉项
gen time2 = (year >= 76) & !missing(year)  //政策执行时间提前到1976年
gen treated2= (idcode >2000)&!missing(idcode) //政策执行地方为idcode大于2000的地方
gen did2 = time2*treated2  //这就是需要估计的DID，也就所交叉项
xtreg ln_w did1 $xlist i.year,fe 
xtreg ln_w did2 $xlist i.year,fe //看看这两式子里did1和did2显著不

**3.控制组将不受到政策的影响
gen time = (year >= 77) & !missing(year)  
gen treated3= (idcode<1600 & idcode>1000)&!missing(idcode) //我们考虑一个并没有受政策影响地方假设其受到政策影响
gen did3 = time*treated3  
xtreg ln_w did3 $xlist i.year,fe //最好的情况是did3不显著，证明控制组不受政策影响

**4.政策实施的唯一性，至少证明这个政策才是主要影响因素
gen time = (year >= 77) & !missing(year)  
gen treated4= (idcode<3000 & idcode>2300)&!missing(idcode) //我们寻找某些受到其他政策影响的地方
gen did4 = time*treated4  
xtreg ln_w did4 $xlist i.year,fe //did4可能依然显著，但是系数变小，证明还受到其他政策影响

**5.控制组和政策影响组的分组是随机的
xi:xtivreg2 ln_w (did=hours tenure) $xlist i.year,fe first //用工具变量来替代政策变量，解决因为分组非随机导致的内生性问题
6.	PSM模型
用途：用于观测数据中的因果推断，通过匹配处理组和对照组来减少选择偏差。
例子：研究培训计划对员工晋升的影响时，PSM可以用于匹配参加培训和未参加培训的员工。
*导入基础数据
use macrodata_basic.dta, clear
*生成解释变量的虚拟变量形式
bys year Industry:egen PLD_RATE1_meidan=median(PLD_RATE1)
gen if PLD_RATE1 = (PLD_RATE1 >= PLD_RATE1_meidan) if !missing(PLD_RATE1)

***************PSM——近邻匹配 使用最近邻匹配1：1原则***************
psmatch2 if PLD_RATE1（解释变量的虚拟变量形式）匹配变量，outcome（被解释变量）logit neighbor(1) common ate ties
*匹配效果检验
pstest, both
*画核密度图
*匹配之前
tw(kdensity _pscore if _treat==0)(kdensity _pscore if _treat==1)
graph export 匹配前.png, as(png) replace
*匹配之后
tw(kdensity _pscore if _treat==0 & _wei!=.)(kdensity _pscore if _treat==1 & _wei!=.)
graph export 匹配后.png, as(png) replace
*匹配后基本回归结果
reg 被解释变量 解释变量 控制变量 i.indcd i.year if _weight!=.
est store ml
esttab ml using PSM-近邻匹配结果.rtf, replace b(%6.4f) t(%6.4f) ar2
nogaps star(* 0.1 ** 0.05 *** 0.01)
***************PSM——核匹配***************
psmatch2 if PLD_RATE1（解释变量的虚拟变量形式）匹配变量，outcome（被解释变量）logit kernel common ate ties
*匹配后基本回归结果
reg 被解释变量 解释变量 控制变量 i.indcd i.year if _weight!=.
est store m2
rsttab m2 using PSM-核匹配结果.rtf, replace b(%6.4f) t(%6.4f) ar2
nogaps star(* 0.1 ** 0.05 *** 0.01)
***************PSM——半径匹配***************
psmatch2 if PLD_RATE1（解释变量的虚拟变量形式）匹配变量，outcome（被解释变量）logit common radius caliper(.01) ate ties
*匹配后基本回归结果
reg 被解释变量 解释变量 控制变量 i.indcd i.year if _weight!=.
est store m3
esttab m3 using PSM-半径匹配结果.rtf, replace b(%6.4f) t(%6.4f) ar2
nogaps star(* 0.1 ** 0.05 *** 0.01)
7.	PSM-DID模型
用途：它结合了倾向得分匹配法（PSM）和双重差分法（DID），有效地解决处理组和对照组之间存在的可观测和不可观测的混杂因素。
***调取数据
webuse nlswork
***告诉stata我是面板数据
xtset idcode year, delta(1)
***描述面板数据情况
xtdescribe 
gen age2= age^2
gen ttl_exp2=ttl_exp^2
gen tenure2=tenure^2
global xlist "grade age age2 ttl_exp ttl_exp2 tenure tenure2 not_smsa south race"
sum ln_w $xlist  //统计描述相关变量
——————————————————————————————————
**********************传统DID方法
*政策执行时间为1977年
gen time = (year >= 77) & !missing(year) 
*政策执行地方为idcode大于2000的地方
gen treated = (idcode >2000)&!missing(idcode) 
*政策变量
gen did = time*treated 
*OLS估计，也可以用diff命令
reg ln_w did time treated $xlist 
xtreg ln_w did time treated $xlist i.year, fe
——————————————————————————————————
************************PSM-DID方法
***************************************PSM的部分
*定义种子
set seed 0001 
*生成随机数
gen tmp = runiform()
*把数据库随机整理
sort tmp 
*通过近邻匹配（这个地方可以选择其他匹配方法）
psmatch2 treated $xlist, out(ln_w) logit ate neighbor(1) common caliper(.05) ties 
*检验协变量在处理组与控制组之间是否平衡
pstest $xlist, both graph
*去掉不满足共同区域假定的观测值
gen common=_support
drop if common == 0  
*************************** DID的部分，根据上面匹配好的数据
reg ln_w did time treated $xlist 
xtreg ln_w did time treated $xlist i.year, fe
8.	滞后期模型
用途：用于探究先前时期的变量值（滞后期变量）对当前时期因变量的影响。
例子：分析上一年度的研发投入对本年度专利产出的影响。
*被解释变量滞后1期：使用F.
xtset stkcd year
xtreg F.被解释变量 解释变量 控制变量1 控制变量2 i.year i.industry
est store ml
esttab ml using 滞后期回归1.rtf, replace nogap ar2 b(%6.4f) t(%6.4f)
star(* 0.1 ** 0.05 *** 0.01)
*解释变量滞后期：使用L.
xtsset stkcd year
xtreg 被解释变量 L.解释变量 控制变量1 控制变量2 i.year i.industry
est store m2
esttab m2 using 滞后期回归2.rtf, replace nogap ar2 b(%6.4f) t(%6.4f)
star(* 0.1 ** 0.05 *** 0.01)
（七）收敛性分析
1.	σ收敛
tabstat gtfp, stats(cv) by(year)
2.	β收敛
*命令安装*
ssc install spcs2xt
*LM检验，目的是判断使用何种模型进行β收敛检验*
use MATRIX.dta,clear//加载空间权重矩阵
set matsize 5000//扩容面板数据维度，面板数据做空间计量占用矩阵维度较大，若不扩容可能会报错
spcs2xt v*,matrix(W1) time(14) //增加空间权重矩阵的时间维度以匹配面板数据，注意此处time写了实际年份-1，因为后续变量做了滞后1期处理，W1为新的空间权重矩阵名称
spatwmat using W1xt.dta,name(Wxt1) standardize//W1xt为spcs2xt命令生成的空间权重矩阵，存储为Wxt1供后续调用
use  GTFP.dta//载入面板数据
xtset id year
gen log_gtfp=log(gtfp)
gen dgtfp=D.log_gtfp
gen lgtfp=L.log_gtfp//按照绝对β收敛模型构建新的变量
drop if year==2005//因dgtfp滞后了1期故删除数据空缺年份，否则会报错（也可通过多找1年数据解决，此时实际年份数需要与前述spcs2xt命令中time的数字一致）
reg dgtfp lgtfp
spatdiag,weights(Wxt1)//输出LM检验结果
*LM检验结果解读：
对比LM-error与LM-lag统计量的p值
1两者均不显著：选OLS
2仅LM-error显著：选SEM
3仅LM-lag显著：选SAR（SLM）
4两者均显著：看Robust LM检验结果
4.1仅Roubust LM-error显著：选SEM
4.2仅Roubust LM-lag显著：选SAR（SLM）
4.3两者均显著：选SDM
4.4两者均不显著：选OLS（需结合其他检验综合判断）*
*绝对β收敛回归*
use MATRIX.dta,clear
set matsize 5000
spcs2xt v*,matrix(W2) time(15) //重新生成实际年份数供回归时使用
spatwmat using W2xt.dta,name(W2) standardize//存储为W2供后续调用
use  GTFP.dta
xtset id year
gen log_gtfp=log(0.01+gtfp)
gen dgtfp=D.log_gtfp
gen lgtfp=L.log_gtfp
egen m = rowmiss(_all)
drop if m>0//删除所有空缺值否则后续回归可能报错
xsmle dgtfp lgtfp,fe wmat(W2) model(sdm) nolog noeffects type(both) hausman r
*回归命令后缀含义：
model(sdm/sem/sar/sac)：模型选择，空间杜宾模型SDM/空间误差模型SEM(此时wmat需改为emat)/空间滞后模型SAR(SLM)/广义空间模型SAC(只能做固定效应，需同时存在wmat与emat)
fe/re：固定效应/随机效应
type(both/time/ind)：固定效应时，选择双向固定效应/实现固定效应/个体固定效应
hausman：Hausman检验（p值小于0.1则选择固定效应）
r：robust简写，使用稳健标准误
nolog：不输出迭代过程
effects/noeffects：是否输出直接效应、间接效应结果*
*Wald检验验证SDM模型是否会退化为SEM/SAR(SLM)模型*
xsmle dgtfp lgtfp,fe wmat(W2) model(sdm) nolog noeffects
test [Wx]lgtfp=0
testnl [Wx]lgtfp=-[Spatial]rho*[Main]lgtfp
*Wald检验结果解读
第1个p值小于0.1则说明SDM模型不会退化为SAR(SLM)模型
第2个p值小于0.1则说明SDM模型不会退化为SEM模型*
*判断SDM、SEM和SAR（SLM）模型何种更优*
qui xsmle dgtfp lgtfp,fe wmat(W2) model(sdm) nolog noeffects
est store sdm
qui xsmle dgtfp lgtfp,fe emat(W2) model(sem) nolog noeffects
est store sem
qui xsmle dgtfp lgtfp,fe wmat(W2) model(sar) nolog noeffects
est store sar
lrtest sdm sem, df(9)
lrtest sdm sar, df(9)
lrtest sem sar, df(9)
*判断固定效应模型中个体固定、时间固定、双向固定何种更优*
qui xsmle dgtfp lgtfp,fe wmat(W2) model(sdm) nolog noeffects type(ind)
est store ind
qui xsmle dgtfp lgtfp,fe wmat(W2) model(sdm) nolog noeffects type(time) 
est store time
qui xsmle dgtfp lgtfp,fe wmat(W2) model(sdm) nolog effects type(both)
est store both
lrtest both ind, df(9)
lrtest both time, df(9)
（八）检验分析
1.	豪斯曼检验
*豪斯曼检验：面板数据回归中，用于选择固定效应模型还是随机效应模型。一般选择标准为显著性在0.1及其以下选择固定效应，否则选择随机效应。
xtreg y x x1 x2 x3, re
est store re
xtreg y x x1 x2 x3, re
est store fe
hausman fe re
2.	Heckman两阶段检验
*用途：Heckman两阶段方法主要用于解决样本选择偏差问题。
Heckman 被解释变量 控制变量, select(D(解释变量虚拟变量) = Z(工具变量其他影响因素) X(控制变量)) twostep
3.	调节效应检验
*用途：调节效应检验用于评估一个或多个变量（调节变量）如何影响其他变量之间的强度和方向
*y为被解释变量，x为解释变量，x1 x2 x3为控制变量；m为调节变量
reg y x x1 x2 x3//回归1
reg y x m x1 x2 x3//回归2
reg y x m x*m x1 x2 x3//回归3
*若回归1中的x显著，回归3中的x和m的乘积项显著，则存在调节效应
4.	中介效应检验
*用途：中介效应检验用于评估某个变量（中介变量）在因变量和自变量之间的作用机制。
*法1：回归模型三阶段法
reg y x x1 x2 x3//(1)：y为被解释变量，x为解释变量，x1 x2 x3为控制变量
reg Z x x1 x2 x3//(2)：Z为中介变量
reg y x Z x1 x2 x3//(3)：(1)中的x要显著 (2)中的x要显著 (3)中的x和Z要显著，则存在中介效应
*法2：Sobel-Goodman检验
sgmediation y, mv(x) iv(Z) cv(x1 x2 x3)//y为被解释变量，x为解释变量，x1 x2 x3为控制变量，Z为中介变量。
*检验结果中：Indirect effect:中介效应，Direct effect:直接效应
*法3：Bootstrap检验
bootstrap r(ind_eff) r(dir_eff), reps(1000):segmediation y, mv(x) iv(Z) cv(x1 x2 x3)
*检验结果：简介效应ind_eff(_bs_1)、直接效应dir_eff(_bs_2)、中介效应占比=_bs_1/(_bs_1+_bs_2)
estat bootstrap, percentile bc
*结果分析：计算间接效应ind_eff(_bs_1)的置信区间（检验中介效应：若该置信区间不包括0，则拒绝H0）；若直接效应dir_eff(_bs_2)的置信区间不包括0就表明是"部分中介效应"；若直接效应dir_eff(_bs_2)的置信区间包括0就表明是"完全中介效应"。
（九）t检验、z检验、卡方检验以及F检验
1.	t检验
t检验是用来比较两个正态分布总体的均值是否相等的方法，分为独立样本t检验和配对样本t检验。在STATA中，可以使用`ttest`命令进行t检验，具体的语法如下：
ttest varname1 [==/= varname2] [if] [in] [weight] [, by(groupvar) unpaired unequal level(#) graph]
其中，`varname1`和`varname2`是需要进行检验的变量，如果只有一个变量，则进行单样本t检验，如果有两个变量，则进行配对样本t检验；`by(groupvar)`选项是用来指定分组变量，进行独立样本t检验；`unpaired`选项是用来指定不进行配对样本t检验，即使有两个变量；`unequal`选项是用来指定不假设两个总体的方差相等，即进行方差不齐的t检验；`level(#)`选项是用来指定显著性水平，默认为0.05；`graph`选项是用来绘制两个样本的均值和置信区间的图形。
例如，如果想要比较男女学生的数学成绩是否有显著差异，可以输入以下命令：
ttest math, by(sex)
2.	z检验
z检验是用来比较两个大样本（n>30）正态分布总体的均值是否相等的方法，或者比较一个大样本的均值是否等于某个已知的值。在STATA中，可以使用`ztest`命令进行z检验，具体的语法如下：
ztest varname1 [==/= varname2] [if] [in] [weight] [, by(groupvar) level(#) graph]
其中，`varname1`和`varname2`是需要进行检验的变量，如果只有一个变量，则进行单样本z检验，如果有两个变量，则进行双样本z检验；`by(groupvar)`选项是用来指定分组变量，进行双样本z检验；`level(#)`选项是用来指定显著性水平，默认为0.05；`graph`选项是用来绘制两个样本的均值和置信区间的图形。
例如，如果想要比较一个样本的均值是否等于50，可以输入以下命令：
ztest varname == 50
3.	卡方检验
卡方检验是用来比较两个或多个分类变量之间的关联性或独立性的方法，或者比较一个分类变量的分布是否符合某个理论分布的方法。在STATA中，可以使用`tabulate`命令进行卡方检验，具体的语法如下：
tabulate varname1 [varname2] [if] [in] [weight] [, chi2 expected row col]
其中，`varname1`和`varname2`是需要进行检验的分类变量，如果只有一个变量，则进行拟合优度卡方检验，如果有两个变量，则进行列联表卡方检验；`chi2`选项是用来显示卡方统计量和p值；`expected`选项是用来显示期望频数；`row`选项是用来显示行百分比；`col`选项是用来显示列百分比。
例如，如果想要比较学生的性别和专业是否有关联，可以输入以下命令：
tabulate sex major, chi2
4.	F检验
F检验是用来比较两个或多个正态分布总体的方差是否相等的方法，或者比较一个回归模型的拟合优度是否显著的方法。在STATA中，可以使用`sdtest`命令进行F检验，具体的语法如下：
sdtest varname1 [==/= varname2] [if] [in] [weight] [, by(groupvar) level(#) graph]
其中，`varname1`和`varname2`是需要进行检验的变量，如果只有一个变量，则进行单样本F检验，如果有两个变量，则进行双样本F检验；`by(groupvar)`选项是用来指定分组变量，进行多样本F检验；`level(#)`选项是用来指定显著性水平，默认为0.05；`graph`选项是用来绘制两个样本的标准差和置信区间的图形。
例如，如果想要比较三个班级的学生的数学成绩的方差是否相等，可以输入以下命令：
sdtest math, by(class)
（十）空间计量模型相关命令
1.	空间相关性检验（Moran检验）
clear
cd"C:\Program Files (x86)\Stata14\ado"  //定义路径，自己建立文件夹，将需要用到的矩阵和数据放进去。定义路径步骤：File—change working directory-找到目标文件夹
spatwmat using D,name(w) standardize  // D为矩阵，w 是矩阵行标准化新的命名，自己可以随意取。standardize为行标准化，可以根据自己的需要，选择是否需要进行行标准化
use shuju                           //shuju是自己的计算数据
keep if year==2009                 //可以逐年计算莫兰指数
spatgsa y,weights(w) moran geary twotail
2.	LM检验
clear all
cd"C:\Program Files (x86)\Stata14\ado"   //定义路径
set matsize 5000
use D                                   //D为矩阵名称
spcs2xt var1-var30,matrix(aaa)time(9)
spatwmat using aaaxt,name(w)
clear
use shuju                      //调用论文数据huiguishuju1 
encode province,gen(pro)      //定义地区变量
xtset pro year               //定义时间变量
gen lny=ln(y)               //如果需要对变量取对数，则执行以下命令,不需要则自动忽略
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
reg lny lnx1 lnx2 lnx3 
spatdiag,weights(w)
3.	Hausman检验（固定效应与随机效应检验选择检验）
clear
cd"C:\Program Files (x86)\Stata14\ado"//定义路径
use shuju                             //调用数据
spatwmat using D, name(w)standardize  //调用矩阵D，并根据研究需要选择进行矩阵行标准化
encode province,gen(pro)
xtset pro year
gen lnny=ln(y)                      //根据研究需要，选择是否对变量取对数
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
xsmle lny lnx1 lnx2 lnx3, fe model(sdm) wmat(w) nolog noeffects
est store fe
xsmle lny lnx1 lnx2 lnx3, re model(sdm) wmat(w) nolog noeffects
est store re
hausman fe re
4.	检验地区固定效应、时间固定效应以及双固定效应，三种效应哪个最适合本文的研究
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(ind)nolog effects
est store ind
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(time)nolog effects
est store time
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(both)nolog effects
est store both
lrtest both ind,df(10)
lrtest both time,df(10)
drop _est_ind _est_time _est_both
5.	LR 检验（用来检验SDM模型能否退化为SEM、SAR模型）
xsmle y x1 x2 x3,fe model(sdm)wmat(w)type(both)nolog effects
est store sdm
xsmle y x1 x2 x3,fe model(sar)wmat(w)type(both)nolog effects
est store sar
xsmle y x1 x2 x3,fe model(sem)emat(w)type(both)nolog effects
est store sem
lrtest sdm sar   //H0：空间杜宾模型可以简化为空间滞后模型
lrtest sdm sem  //H0：空间杜宾模型可以简化为空间误差模型
6.	WALD检验（也是用来检验模型的适配性）
clear all
cd"C:\Program Files (x86)\Stata14\ado"//定义路径
use shuju                             //调用数据
spatwmat using D.dta,name(w) standardize //调用数据矩阵D，并将其还行标准化
encode province,gen(pro)
xtset pro year
gen lny=ln(y)
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(both)nolog noeffects 

test [Wx]x1 = [Wx]x2 = [Wx]x3=0
testnl ([Wx]x1 = -[Spatial]rho*[Main]x1)([Wx]x2 = -[Spatial]rho*[Main]x2)([Wx]x3= -[Spatial]rho*[Main]x3)
7.	SDM模型回归（空间杜宾模型）
clear all
cd"C:\Program Files (x86)\Stata14\ado"//定义路径
use shuju                             //调用数据
spatwmat using D.dta,name(w) standardize //调用数据矩阵D，并将其还行标准化
encode province,gen(pro)
xtset pro year
gen lny=ln(y)
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(both)nolog noeffects  //fe和type(both)可以根据文章hausman检验和固定效应、时间效应、双向固定效应检验的结果进行相应的变换。
8.	SAR模型回归（空间滞后模型）
xsmle lny lnx1 lnx2 lnx3,fe model(sar) wmat(w)type(both)nolog noeffects
9.	SEM模型回归（空间误差模型）
xsmle  lny lnx1 lnx2 lnx3,fe model(sem) emat(w)type(both)nolog noeffects
（十一）结果导出
1.	导出描述性统计
*输入论文的代码写法：该代码直接输出论文格式，简单调整即可
sum2docx 变量1 变量2 变量3 using 描述性统计.docx, replace stats(N mean(%9.4f) sd min(%9.4f) median(%9.2f) max(%9.2f)) title("Table2:Summary Statistics")
*outreg2 导出
outreg2 using xxx.doc, replace sum(log) title(Decriptive statistics)//xxx.doc为输出文件名；sum(log)即输出一般统计指标命令，一般统计指标包括样本数、中值、标准误、最大值和最小值
outreg2 using xxx.doc, replace sum(detail) title(Decriptive statistics)
2.	导出相关系数
*导出相关系数，需要先下载pwcorr_a命令包
logout, save(相关系数分析) word replace:pwcorr_a 变量1 变量2 变量3, starl(.01) star5(.05) star10(.1)
3.	
4.	导出回归结果
展示回归结果
reg y x x1 x2 x3
est store a1
xtreg y x x1 x2 x3, re
est store a2
xtreg y x x1 x2 x3, fe
est store a3
esttab a1 a2 a3 using 回归结果.rtf, replace b(%6.4f) t(%6.4f) nogap
ar2 star(*0.1 ** 0.05 *** 0.01)
线性回归结果
sysuse auto, clear
reg price mpg
outreg2 using xxx.doc, replace tstat bdec (3) tdec(2) ctitle(y)
/* ctitle 为自定义表格内标题命令，如果不进行设定则直接输出为被解释变量名：按照 outreg2 命令输出的表格内相关系数下括号内数字为标准误，因此我们一般利用命令 tstat 将其更改为 t 值:相关系数bdec(3)保留3位有效数字；t值tdec(2)，保留2位有效数字 */
面板数据的回归结果
webuse grunfeld, clear
xtset company year
xtreg invest mvalue kstock, fe robust
outreg2 using xxx.doc, replace tstat bdec(3) tdec(2) ctitle(y) keep(invest mvalue kstock) addtext(Company FE, YES ) // addtext 为在表中增加信息命令，由于 Stata 进行固定效应回归后单纯利用 outreg2 命令输出不会展示是否控制固定效应，因此我们需要利用 addtext 命令追加。
工具变量法的回归结果
sysuse auto
ivregress2 2sls mpg weight (length=displacement),first
est restore first
outreg2 using xxx.doc, cttop(first) tstat bdec(3) tdec(2) replace
ivregress2 2sls mpg weight (length=displacement), first
outreg2 using xxx.doc, cttop(two) tstat bdec(3) tdec(2)
按照 outreg2 命令输出的表格内相关系数下括号内数字为标准误，利用命令tstat 将其更改为 t 值。
outreg2 命令输出时默认相关系数和 t 值都保留 3 位有效数字，而一般期刊要求相关系数保留3位有效数字,t 值保留2位有效数字,因此利用 bdec(3)和 tdec(2)命令限定。
