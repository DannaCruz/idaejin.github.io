---
title: '**Introduction to Statistical Modelling in `R`**'
author: "Dae-Jin Lee < dlee@bcamath.org >"
date: 'BCAM-UPV/EHU Courses 2018-2019'
output:
  slidy_presentation:
    fig_caption: yes
    font_adjustment: 5
    highlight: monochrome
    incremental: yes
    keep_md: yes
    theme: cerulean
  ioslides_presentation:
    highlight: monochrome
---

***********

# Introduction to the `R` language 


## Installing `R`

- Latest version of `R`. Download it [here](https://cran.r-project.org/)

## The RStudio environment

- Rstudio is a user-friendly interface. Download it [here](https://www.rstudio.com/products/rstudio/download/) **Highly recommended!!!**


## Start with `R`

* Get current working directory 


```r
getwd() 
```

* list the objects in the current workspace


```r
ls()
```

* Set working directory


```r
setwd("/Users/dlee") 
```

* work with your previous commands


```r
history() # display last 25 commands
history(max.show=Inf) # display all previous commands
```


* save your command history


```r
savehistory(file="myfile") # default is ".Rhistory"
```

* recall your command history


```r
loadhistory(file="myfile") # default is ".Rhistory"
```


* save the workspace to the file `.RData` 


```r
save.image()
```

* save specific objects to a file  if you don't specify the path, the cwd is assumed


```r
save(<object list>,file="myfile.RData") 
```


* load a workspace into the current session


```r
load("myfile.RData") 
```


* quit `R`. You will be prompted to save the workspace. 


```r
q()
```


## Install and load an `R` library
 

```r
install.packages("DAAG") # (Data Analysis And Graphics)
```

or several packages 


```r
install.packages(c("DAAG","HSAUR2","Hmisc","psych","foreign","xlsx"))
```


In Rstudio (go to `package` and click `Install`)



Once installed the package, load it

```r
library(DAAG) # or require(DAAG)
```
 
-------------------------------------

## Reading data

The `R` console



```r
x <- c(7.82,8.00,7.95) # c means "combine"
x
```

```
## [1] 7.82 8.00 7.95
```

A quicker way is to use `scan()`


```r
x <- scan()  # enter a number followed by return and blank line to end
1: 7.82
2: 8.00
3: 7.95
4: 
Read 3 items
```
To create a character vector use `""`


```r
id <- c("John","Paul","George","Ringo")
```


To read a character vector 

```r
id <- scan(,"")
1: John
2: Paul
3: George
4: Ringo
5: 
Read 4 items  
```


```r
id
```

```
## [1] "John"   "Paul"   "George" "Ringo"
```


## Data Import

In most situations, we need to read data from a separate data file. There are several methods for doing this. 

* `scan()` (see `?scan` for help)



```r
cat("Example:", "2 3 5 7", "11 13 17", file = "ex.txt", sep = "\n") # creates ex.txt
scan("ex.txt", skip = 1)
```

```
## [1]  2  3  5  7 11 13 17
```

```r
scan("ex.txt", skip = 1, nlines = 1) # only 1 line after the skipped one
```

```
## [1] 2 3 5 7
```

```r
unlink("ex.data") # tidy up
```

* Several formats are available (`.txt`, `.csv`, `.xls`, `.xlsx`, `SAS`, `Stata`, etc...)

* Some `R` libraries to import data are 


```r
library(gdata)
library(foreign)
```

\bigskip

* Read data from a `.txt` or `.csv` files

Create a folder, name it `data` and download `cars` data ([cardata.zip](data/cardata.zip))



```r
mydata1 = read.table("data/cardata.txt") 
mydata2 = read.csv("data/cardata.csv")  
```

* Other formats `.xls` and `.xlsx`


```r
library(gdata)
mydata3 = read.xls("data/cardata.xls", sheet = 1, header = TRUE)

library(xlsx)
mydata4 = read.xlsx("data/cardata.xlsx", sheetIndex = 1, header = TRUE,colClasses=NA)
```

---------------------------------


* Minitab, SPSS, SAS or Stata


```r
library(foreign)                   
mydata = read.mtp("mydata.mtp")  # Minitab
mydata = read.spss("myfile", to.data.frame=TRUE) # SPSS
mydata = read.dta("mydata.dta") # Stata
```

* Or

```r
library(Hmisc)
mydata = spss.get("mydata.por", use.value.labels=TRUE)  # SPSS
```

-------------------------

## Exporting data

* There are numerous methods for exporting `R` objects into other formats. For SPSS, SAS and Stata. you will need to load the `foreign` packages. For Excel, you will need the `xlsx` package.  
 
 - Tab-delimited text file


```r
mtcars
?mtcars    
write.table(mtcars, "cardata.txt", sep="\t") 
```

*  Excel spreadsheet


```r
library(xlsx)
write.xlsx(mydata, "mydata.xlsx")
```


----------------------------

## Data vectors

* Download `R code` [here](http://idaejin.github.io/bcam-courses/rbasics/rbasics.R)

* Create a vector of weights and heights


```r
weight<-c(60,72,57,90,95,72)  
class(weight)
```

```
## [1] "numeric"
```

```r
height<-c(1.75,1.80,1.65,1.90,1.74,1.91)
```

* calculate Body Mass Index

```r
bmi<- weight/height^2
bmi
```

```
## [1] 19.59184 22.22222 20.93664 24.93075 31.37799 19.73630
```

----------------------------


## Basic statistics 

* mean, median, st dev, variance


```r
mean(weight) 
median(weight)
sd(weight)
var(weight)
```

* summarize data


```r
summary(weight)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   57.00   63.00   72.00   74.33   85.50   95.00
```

* or


```r
min(weight)
max(weight)
range(weight)
sum(weight)
length(weight)
```

* Quantiles and percentile

There are several quartiles of an observation variable. The first quartile, or lower quartile, is the value that cuts off the first 25% of the data when it is sorted in ascending order. The second quartile, or median, is the value that cuts off the first 50%. The third quartile, or upper quartile, is the value that cuts off the first 75%. 


```r
quantile(weight)
```

```
##   0%  25%  50%  75% 100% 
## 57.0 63.0 72.0 85.5 95.0
```

The $n^{\rm th}$ percentile of an observation variable is the value that cuts off the first $n$ percent of the data values when it is sorted in ascending order. 


```r
quantile(weight,c(0.32,0.57,0.98))
```

```
##  32%  57%  98% 
## 67.2 72.0 94.5
```

* Covariance and correlation 


The *covariance* of two variables $x$ and $y$ in a data sample measures how the two are linearly related. A positive covariance would indicate a positive linear relationship between the variables, and a negative covariance would indicate the opposite.


$$
\rm{Cov}(x,y) = \frac{1}{n}\sum_{i=1}^{n}(x_i - \bar{x})(y_i - \bar{y})
$$


```r
cov(weight,height)
```

```
## [1] 0.6773333
```
The *correlation coefficient* of two variables in a data sample is their covariance divided by the product of their standard deviations. It is a normalised measurement of how the two are linearly related.

Formally, the sample correlation coefficient is defined by the following formula, where $\sigma_x$ and $\sigma_y$ are the sample standard deviations, and $\sigma_xy$ is the covariance. 

$$
      \rho_{xy}  = \frac{\sigma_{xy}}{\sigma_x~\sigma_y}
$$


```r
cor(weight,height)
```

```
## [1] 0.437934
```

# Creating your own functions in `R`

One of the great strengths of `R` is the user's ability to add functions. In fact, many of the functions in `R` are actually functions of functions. The structure of a function is given below.


```r
myfunction <- function(arg1, arg2, ... ){
  statements
return(object)
}
```


```r
f <- function(x){
  x^2
    }
f
```

```
## function(x){
##   x^2
##     }
```

*Example:*

```r
# Given a number
f(2)
```

```
## [1] 4
```

```r
# Given a vector
x <- c(1,2,-4,7)
f(x)
```

```
## [1]  1  4 16 49
```

Let us create a function that returns a set of summary statistics given a numeric vector:


```r
mysummary <- function(x){
  mean <- sum(x)/length(x)
   var <- var(x)
    sd <- sd(x)
 range <- range(x)
 result <- list(mean=mean,var=var,sd=sd,range=range)
 return(result)
}
```

Then

```r
set.seed(1234)
x <- rnorm(10)
stats <- mysummary(x)
stats
```

```
## $mean
## [1] -0.3831574
## 
## $var
## [1] 0.9915928
## 
## $sd
## [1] 0.9957875
## 
## $range
## [1] -2.345698  1.084441
```

## Character vectors and factor variables


```r
subject <- c("John","Peter","Chris","Tony","Mary","Jane")
sex <- c("MALE","MALE","MALE","MALE","FEMALE","FEMALE")
class(subject)
```

```
## [1] "character"
```

```r
table(sex)
```

```
## sex
## FEMALE   MALE 
##      2      4
```


-----------------------------------


## Data frames

```r
Dat <- data.frame(subject,sex,weight,height)
# add bmi to Dat
Dat$bmi <- bmi  # or Dat$bmi <- weight/height^2
class(Dat)
```

```
## [1] "data.frame"
```

```r
str(Dat) # display object structure
```

```
## 'data.frame':	6 obs. of  5 variables:
##  $ subject: Factor w/ 6 levels "Chris","Jane",..: 3 5 1 6 4 2
##  $ sex    : Factor w/ 2 levels "FEMALE","MALE": 2 2 2 2 1 1
##  $ weight : num  60 72 57 90 95 72
##  $ height : num  1.75 1.8 1.65 1.9 1.74 1.91
##  $ bmi    : num  19.6 22.2 20.9 24.9 31.4 ...
```



```r
# Change rownames
rownames(Dat)<-c("A","B","C","D","E","F")

# Access to data frame elements (similar to a matrix)
Dat[,1]     # 1st column
```

```
## [1] John  Peter Chris Tony  Mary  Jane 
## Levels: Chris Jane John Mary Peter Tony
```

```r
Dat[,1:3]   # 1st to 3rd columns
```

```
##   subject    sex weight
## A    John   MALE     60
## B   Peter   MALE     72
## C   Chris   MALE     57
## D    Tony   MALE     90
## E    Mary FEMALE     95
## F    Jane FEMALE     72
```

```r
Dat[1:2,]   # 1st to 2nd row
```

```
##   subject  sex weight height      bmi
## A    John MALE     60   1.75 19.59184
## B   Peter MALE     72   1.80 22.22222
```


## Working with data frames

**Example: Analyze data by groups**

*  Obtain the mean weight, height and BMI means by FEMALES and MALES:

1. Select each group and compute the mean


```r
Dat[sex=="MALE",]
Dat[sex=="FEMALE",]

mean(Dat[sex=="MALE",3])  # weight average of MALEs
mean(Dat[sex=="MALE","weight"])
```

2. Use `apply` by columns 

```r
apply(Dat[sex=="FEMALE",3:5],2,mean)
apply(Dat[sex=="MALE",3:5],2,mean)

# we can use apply with our own function
apply(Dat[sex=="FEMALE",3:5],2,function(x){x+2})
```

3. `by` and `colMeans`


```r
# 'by' splits your data by factors and do calculations on each subset.
by(Dat[,3:5],sex, colMeans) 
```

4. `aggregate`


```r
# another option
aggregate(Dat[,3:5], by=list(sex),mean) 
```

------------------------------------

## Logical vectors

* Choose individuals with `BMI>22`

```r
bmi
bmi>22
as.numeric(bmi>22) # convert a logical condition to a numeric value 0/1
which(bmi>22)  # gives the position of bmi for which bmi>22
```

* Which are between $20$ and $25$?


```r
bmi > 20 & bmi < 25
which(bmi > 20 & bmi < 25)
```

--------------------------------------

## Working with vectors 

* Concatenate


```r
x <- c(2, 3, 5, 2, 7, 1)
y <- c(10, 15, 12)
z <- c(x,y)  # concatenates x and y
```

* list two vectors


```r
zz <- list(x,y) # create a list
unlist(zz) # unlist the list converting it to a concatenated vector
```

```
## [1]  2  3  5  2  7  1 10 15 12
```

* subset of vectors


```r
x[c(1,3,4)]
```

```
## [1] 2 5 2
```

```r
x[-c(2,6)] # negative subscripts omit the chosen elements 
```

```
## [1] 2 5 2 7
```

* Sequences

```r
seq(1,9) # or 1:9
```

```
## [1] 1 2 3 4 5 6 7 8 9
```

```r
seq(1,9,by=1)
```

```
## [1] 1 2 3 4 5 6 7 8 9
```

```r
seq(1,9,by=0.5)
```

```
##  [1] 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0
```

```r
seq(1,9,length=20)
```

```
##  [1] 1.000000 1.421053 1.842105 2.263158 2.684211 3.105263 3.526316
##  [8] 3.947368 4.368421 4.789474 5.210526 5.631579 6.052632 6.473684
## [15] 6.894737 7.315789 7.736842 8.157895 8.578947 9.000000
```

* Replicates


```r
oops <- c(7,9,13)
rep(oops,3) # repeats the entire vector "oops" three times
rep(oops,1:3) # this function has the number 3 replaced 
              #  by a vector with the three values (1,2,3) 
              #  indicating that 7 should be repeated once, 9 twice and 13 three times.

rep(c(2,3,5), 4)
rep(1:2,c(10,15))

rep(c("MALE","FEMALE"),c(4,2)) # it also works with character vectors 
c(rep("MALE",3), rep("FEMALE",2))
```

---------------------------------------------


## Matrices and arrays


```r
x<- 1:12
x
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12
```

```r
dim(x)<-c(3,4)  # 3 rows and 4 columns

X <- matrix(1:12,nrow=3,byrow=TRUE)
X
```

```
##      [,1] [,2] [,3] [,4]
## [1,]    1    2    3    4
## [2,]    5    6    7    8
## [3,]    9   10   11   12
```

```r
X <- matrix(1:12,nrow=3,byrow=FALSE)
X
```

```
##      [,1] [,2] [,3] [,4]
## [1,]    1    4    7   10
## [2,]    2    5    8   11
## [3,]    3    6    9   12
```

```r
# rownames, colnames

rownames(X) <- c("A","B","C")
X
```

```
##   [,1] [,2] [,3] [,4]
## A    1    4    7   10
## B    2    5    8   11
## C    3    6    9   12
```

```r
colnames(X) <- LETTERS[4:7]
X
```

```
##   D E F  G
## A 1 4 7 10
## B 2 5 8 11
## C 3 6 9 12
```

```r
colnames(X) <- month.abb[4:7]
X
```

```
##   Apr May Jun Jul
## A   1   4   7  10
## B   2   5   8  11
## C   3   6   9  12
```

* Column/Row bind operations `cbind()`, `rbind()`


```r
Y <- matrix(0.1*(1:12),3,4)

cbind(X,Y)  # bind column-wise
```

```
##   Apr May Jun Jul                
## A   1   4   7  10 0.1 0.4 0.7 1.0
## B   2   5   8  11 0.2 0.5 0.8 1.1
## C   3   6   9  12 0.3 0.6 0.9 1.2
```

```r
rbind(X,Y)  # bind row-wise
```

```
##   Apr May Jun  Jul
## A 1.0 4.0 7.0 10.0
## B 2.0 5.0 8.0 11.0
## C 3.0 6.0 9.0 12.0
##   0.1 0.4 0.7  1.0
##   0.2 0.5 0.8  1.1
##   0.3 0.6 0.9  1.2
```

-----------------------------------------------

## Factors


```r
gender<-c(rep("female",691),rep("male",692))
class(gender)
```

```
## [1] "character"
```

```r
# change vector to factor (i.e. a category)
gender<- factor(gender)
levels(gender)
```

```
## [1] "female" "male"
```

```r
summary(gender)
```

```
## female   male 
##    691    692
```

```r
table(gender)
```

```
## gender
## female   male 
##    691    692
```

```r
status<- c(0,3,2,1,4,5)    # This command creates a numerical vector pain, 
                           #    encoding the pain level of five patients.
fstatus <- factor(status, levels=0:5)
levels(fstatus) <- c("student","engineer","unemployed","lawyer","economist","dentist")

Dat$status <- fstatus
Dat
```

```
##   subject    sex weight height      bmi     status
## A    John   MALE     60   1.75 19.59184    student
## B   Peter   MALE     72   1.80 22.22222     lawyer
## C   Chris   MALE     57   1.65 20.93664 unemployed
## D    Tony   MALE     90   1.90 24.93075   engineer
## E    Mary FEMALE     95   1.74 31.37799  economist
## F    Jane FEMALE     72   1.91 19.73630    dentist
```

-----------------------------------------------

##  Indexing vector with logicals


```r
a <- c(1,2,3,4,5)
b <- c(TRUE,FALSE,FALSE,TRUE,FALSE)

max(a[b])
```

```
## [1] 4
```

```r
sum(a[b])
```

```
## [1] 5
```

## Missing values

In `R`, missing values are represented by the symbol `NA` (not available) . Impossible values (e.g., dividing by zero) are represented by the symbol `NaN` (not a number). 


```r
a <- c(1,2,3,4,NA)
sum(a)
```

```
## [1] NA
```

Excluding missing values from functions


```r
sum(a,na.rm=TRUE)
```

```
## [1] 10
```

```r
a <- c(1,2,3,4,NA)
is.na(a)
```

```
## [1] FALSE FALSE FALSE FALSE  TRUE
```

The function `complete.cases()` returns a logical vector indicating which cases are complete.


```r
complete.cases(a)
```

```
## [1]  TRUE  TRUE  TRUE  TRUE FALSE
```

The function `na.omit()` returns the object with listwise deletion of missing values. 


```r
na.omit(a) 
```

```
## [1] 1 2 3 4
## attr(,"na.action")
## [1] 5
## attr(,"class")
## [1] "omit"
```

`NA` in data frames:


```r
require(graphics)
?airquality
pairs(airquality, panel = panel.smooth, main = "airquality data")
ok <- complete.cases(airquality)
airquality[ok,]
```


## Working with data frames

 * A data frame is used for storing data tables. It is a list of vectors of equal length. 

```r
mtcars
?mtcars       # or help(mtcars)
```

* look at the first rows


```r
head(mtcars)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

* Structure of the data frame


```r
str(mtcars) # display the structure of the data frame
```

```
## 'data.frame':	32 obs. of  11 variables:
##  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
##  $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
##  $ disp: num  160 160 108 258 360 ...
##  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
##  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
##  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
##  $ qsec: num  16.5 17 18.6 19.4 17 ...
##  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
##  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
##  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
##  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
```

* Select a car model:

```r
mtcars["Mazda RX4",] # using rows and columns names
mtcars[c("Datsun 710", "Camaro Z28"),] 
```

* Or specific variables


```r
mtcars[,c("mpg","am")]
```

There are some packages that include particular functions to summarize data frames, for instance the library `psych` has the function `describe`


```r
library(psych)
describe(mtcars)
```

------------------------------------





