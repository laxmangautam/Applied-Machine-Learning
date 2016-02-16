# housekeeping
rm(list=ls())

# libraries
library(klaR)
library(caret)

# import data
# http://www.portfolioprobe.com/user-area/documentation/portfolio-probe-cookbook/data-basics/read-a-tab-separated-file-into-r/
wdat<-read.table('/Users/harry/projects/aml/assignment3/pubfig_dev_50000_pairs.txt')
# v1 is label, rest (v2-v147) are features
bigx<-wdat[,-c(1)] #drop col 1
bigy<-as.factor(wdat[,1]) #coerce col 1 and store as factor (class label)

trscore<-array(dim=10)
testscore<-array(dim=10)
for (wi in 1:10) {
  # partition 80% of data for training
  wtd<-createDataPartition(y=bigy, p=.8, list=FALSE)
  # run svm to generate model
  svm<-svmlight(bigx[wtd,], bigy[wtd], pathsvm='/Users/harry/projects/aml/assignment3/')
  
  # run on training data
  trlabels<-predict(svm, bigx[wtd,])
  trfoo<-trlabels$class
  # evaluate performance on training data
  trscore[wi]<-sum(trfoo==bigy[wtd])/(sum(trfoo==bigy[wtd])+sum(!(trfoo==bigy[wtd])))
  
  # run on testing data (remaining 20%)
  labels<-predict(svm, bigx[-wtd,])
  foo<-labels$class
  #evaluate performance on test data
  testscore[wi]<-sum(foo==bigy[-wtd])/(sum(foo==bigy[-wtd])+sum(!(foo==bigy[-wtd])))
}
trscoremean<-mean(trscore)
testcoremean<-mean(testscore)