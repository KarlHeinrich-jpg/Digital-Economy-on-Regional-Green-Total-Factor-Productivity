cd C:\Users\Administrator\Desktop\更新空间杜宾实证代码  
//自己的数据放在哪个位置就改成那个位置

use data1,clear
//data1需要替换成你自己的数据

***变量的描述性统计
sum y x1 x2 x3 x4 x5 x6 x7
//y x1 x2 x3 x4 x5 x6 x7为自己的被解释变量和解释变量

***空间权重矩阵制作
spatwmat using W2.dta, n(W2)
matrix list W2
//w2是自己的矩阵

***空间相关性检验
**Moran’ s I指数
*（1）计算全局莫兰指数
//（可以从最后一个指数往前数，最后一个就是2020年的莫兰指数）

spatwmat using W2.dta, n(W2) standardize
matrix list W2

//=============================！！！！！从preserve到restore务必视为一个整体，选中一起执行！！============

preserve 
keep if year==2009      
spatgsa y,weights(W2) moran  twotail 
restore
//这个代码只能一次求一个莫兰指数，改变年份2009即可，下面的循环语句代码可以一次性求出每一年的莫兰指数

forvalue i  = 2009/2020{
	preserve  
	keep if year==`i'
	spatgsa y,weights(W2) moran twotail  
	restore 
}
//计算全局莫兰指数，上面的代码运用了一个循环语句自动算出每一年的莫兰指数。其中2009/2020需要换成自己的年份


*（2）计算局部莫兰指数
use data1,clear
xtset id year
spatwmat using W2.dta, n(W2) standardize
preserve 
keep if year==2009     
spatlsa y,weights(W2) moran twotail    
restore
//改变年份2009，可计算不同年份

**moran散点图
//方法一，为显示地名的莫兰散点图
preserve 
keep if year==2019   //改变年份2019，可画不同年份的散点图
spatlsa y,weights(W2)moran graph(moran) symbol(id) id(pro)  //显示地名
restore
//方法二，为不显示地名的莫兰散点图
preserve 
keep if year==2020     //改变年份2020，可画不同年份的散点图
splagvar y , wname(W2) wfrom(Stata) moran(y) plot(y)
restore

**1LM检验
//此处最容易犯的错，就是将数据复制到stata时会莫名其妙多出一些小短横，所以需要将data、w2和w02都拉到最后看看有没有小短横或者缺失值。还有就是数值比较大的变量需要进行取对数处理,不然很可能运行不出来

clear all
use data1, clear
use W02
spcs2xt a1-a30,matrix(aaa)time(12)  
spatwmat using aaaxt,name(W)
clear
use data1                                           
xtset id year   
reg y x1 x2 x3 x4 x5 x6 x7 
spatdiag,weights(W)

//W02为矩阵名称，与w2的数据是一样的，但是需要加上行名和列名，具体请查看原W02的特征。w02也需要换成自己的矩阵数据。
//a1-a30要根据实际w02的数据内容更改，如果只研究10个地区，则应改为a1-a10，若有20个省份，则改为a1-a20。time（）里面的数字要根据自己的数据年份更改。此处09-20年，时间期限为12。


**wald检验和LR检验实际只要满足一个即可。但如果两个检验都能满足，建议都写。
**2Wald检验
clear all
use data1
spatwmat using W2.dta,name(W2) standardize 
xtset id year
xsmle y x1 x2 x3 x4 x5 x6 x7 , fe model(sdm) wmat(W2) type(both) nolog noeffects
//Wald Test for SAR
test [Wx]x1 = [Wx]x2 = [Wx]x3 = [Wx]x4= [Wx]x5=[Wx]x6=[Wx]x7=0
//Wald Test for SEM
testnl ([Wx]x1 = -[Spatial]rho*[Main]x1)([Wx]x2 = -[Spatial]rho*[Main]x2)([Wx]x3= -[Spatial]rho*[Main]x3)([Wx]x4=-[Spatial]rho*[Main]x4)([Wx]x5=-[Spatial]rho*[Main]x5)([Wx]x6=-[Spatial]rho*[Main]x6)([Wx]x7=-[Spatial]rho*[Main]x7)

**3LR检验
xsmle  y x1 x2 x3 x4 x5 x6 x7, fe model(sdm) wmat(W2) type(both) nolog noeffects
est store sdm
xsmle y x1 x2 x3 x4 x5 x6 x7  , fe model(sar) wmat(W2) type(both) nolog noeffects
est store sar
xsmle y x1 x2 x3 x4 x5 x6 x7  , fe model(sem) emat(W2) type(both) nolog noeffects
est store sem
lrtest sdm sar  //H0：空间杜宾模型可以简化为空间滞后模型（SAR）
lrtest sdm sem  //H0：空间杜宾模型可以简化为空间误差模型（SEM）

**4Hausman检验
//若是空间误差模型需要将下面代码中的model(sdm) wmat(W2)改成model(sem) emat(W2)，若是空间滞后模型，需要将下面的代码其中model(sdm)改成model(sar)

//方法一
clear all
use data1
spatwmat using W2.dta,name(W2) standardize 
xtset id year
xsmle y x1 x2 x3 x4 x5 x6 x7 , fe model(sdm) wmat(W2)  nolog noeffects type(both)
est store fe
xsmle  y x1 x2 x3 x4 x5 x6 x7, re model(sdm) wmat(W2)  nolog noeffects type(both)
est store re
hausman fe re

//方法二，如果方法一不行，用方法二，有些数据方法二运行不出来，可能数据量太大不行
xtset id year
spatwmat using W2.dta,name(W2) standardize 
xsmle  y x1 x2 x3 x4 x5 x6 x7, model(sdm) wmat(W2) hausman nolog noeffects


**5固定效应类型检验
use data1,clear
xtset id year
spatwmat using W2.dta, n(W2) standardize
xsmle y x1 x2 x3 x4 x5 x6 x7 , fe  model(sdm) wmat(W2) nolog noeffects type(ind)
est store ind
xsmle y x1 x2 x3 x4 x5 x6 x7  , fe  model(sdm) wmat(W2) nolog noeffects type(time)
est store time
xsmle y x1 x2 x3 x4 x5 x6 x7 , fe  model(sdm) wmat(W2) nolog noeffects type(both)
est store both
lrtest both ind,df(29)  //比较“双向”和“个体”效应  LR检验 df（）括号里面的数字一般比研究个体少1
lrtest both time,df(11)  //比较“时间”和“双向”效应  LR检验
//df（）括号里面的数字一般比研究时间少1

*将以上结果输出到word
use data1,clear
xtset id year
spatwmat using W2.dta, n(W2) standardize
xsmle y x1 x2 x3 x4 x5 x6 x7 , fe  model(sdm) wmat(W2) nolog noeffects type(ind)
est store ind
xsmle y x1 x2 x3 x4 x5 x6 x7  , fe  model(sdm) wmat(W2) nolog noeffects type(time)
est store time
xsmle y x1 x2 x3 x4 x5 x6 x7 , fe  model(sdm) wmat(W2) nolog noeffects type(both)
est store both
drop _est_ind _est_time _est_both
local m " ind time both"
esttab `m', mtitle(`m') nogap s(r2 N )
logout, save(Descriptive2) word replace: esttab `m', mtitle(`m') nogap s(r2 N ) //输出到word


**空间杜宾效应分解
clear all
use data1
spatwmat using W2.dta,name(W2) standardize 
xtset id year 
xsmle y x1 x2 x3 x4 x5 x6 x7, fe model(sdm) wmat(W2)  nolog effects type(both)
est store both
//以下代码一起运行输出到word
drop  _est_both
local m "  both"
esttab `m', mtitle(`m') nogap s(r2 N )
logout, save(Descriptive2) word replace: esttab `m', mtitle(`m') nogap s(r2 N ) 
//用双固定就写both
//用个体固定就写ind
//用时间固定就用time

*若是空间误差模型则是以下代码，误差模型不能分解，x*表示x1 x2 x3 x4 x5 x6 x7
use data1,clear
xtset id year
spatwmat using W2.dta, n(W2) standardize
*随机效应模型
xsmle y x*, model(sem) emat(W2) type(both) nolog effects re
*时间固定效应
xsmle y x* , model(sem) emat(W2) type(time) nolog effects fe 
*个体固定效应
xsmle y x* , model(sem) emat(W2) type(ind) nolog effects fe 
*双固定效应
xsmle y x* , model(sem) emat(W2) type(both) nolog effects fe 


*若是空间滞后模型分解则是以下代码
**空间滞后模型（SLM）
*随机效应模型
xsmle y x* , model(sar) wmat(W2) type(both) nolog effects re
*时间固定效应
xsmle y x* , model(sar) wmat(W2) type(time) nolog effects fe 
*个体固定效应
xsmle y x* , model(sar) wmat(W2) type(ind) nolog effects fe 
*双固定效应
xsmle y x*, model(sar) wmat(W2) type(both) nolog effects fe 





 
