use "D:\stata\personal\中部六省数据.dta",clear
xtset id year
//标准化------------------------------------------------------------------------
global all_var x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18
foreach i in $all_var{
egen min_`i'=min(`i')
egen max_`i'=max(`i')
gen s`i'=(`i'-min_`i')/(max_`i'-min_`i')  //正向指标，负向指标自己写吧
replace s`i'=0.0001 if s`i'==0
}

order id province year x* min* max* s*

//求p---------------------------------------------------------------------------
forvalue i=1(1)18{ //这篇文章是18个变量，且是按顺序命名的，才可以这样用
egen sums_`i'=sum(sx`i')
gen p`i'=sx`i'/sums_`i'
}

order id province year x* min* max* s* sums* p*

//求e和d------------------------------------------------------------------------
forvalue i=1(1)18{
egen l`i'=sum(p`i'*ln(p`i'))
gen e`i'=-l`i'/ln(48)  //obs的个数，数据拉到底就知道了
gen d`i'=1-e`i'
}

order id province year x* min* max* s* sums* p* l* e* d*

//求权重w-----------------------------------------------------------------------
forvalue i=1(1)18{
egen f`i'=rowtotal(d*)
gen w`i'=d`i'/f`i'
} //w就是权重，很多论文到这一步就行了

order id province year x* min* max* s* sums* p* l* e* d* f* w*

//计算得分----------------------------------------------------------------------

forvalue i=1(1)18{
gen score`i'=w`i'*sx`i' //千万注意是标准化之后的变量和权数相乘啊
}

egen Score = rowtotal(sc*)

keep province id year w* Score
























