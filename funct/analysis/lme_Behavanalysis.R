lme_Behavanalysis <- function(tablefname) {
  
  library("nlme")
  library("dplyr")  
  
  COVARS=cbind("ID","Load")
  
  VAR="RTLoadmean"
  
  outdir<-dirname(tablefname)
  
  data<-read.table(tablefname,header = T, sep = ",")
  
  dataCOVARS=select(data,COVARS)

    VARmatch<-which(names(data)==VAR)
    
    newdat<-cbind(data[,VARmatch],dataCOVARS)
    names(newdat)[1]<-"y"
    
    lmer<-lme(y ~ Load, data=newdat, random = ~ Load|ID)
    
    #conf<-confint(lmerInt, method="boot", nsim=5000)
    
    out<-summary(lmer)
    
    fixedcoeffs<-as.data.frame(out$coefficients$fixed)
    
    npreds<-length(row.names(fixedcoeffs))
    outstats<-matrix(, nrow = as.numeric(npreds), ncol = 5)
    
    for(j in 1:npreds)
    {
      outstats[j,1]<-row.names(fixedcoeffs)[j]
    }
    
    anovaout<-anova(lmer)
    
    outstats[,2:5]<-c(out$coefficients$fixed, anovaout[,2],anovaout[,3],anovaout[,4])
    #outstats[,6:7]<-conf[3:length(conf[,1]),1:2]
    
    outstats<-as.data.frame(outstats)
    names(outstats)<-c("Predictor","Estimate","df","F","p")
    
    fname<-paste(VAR,"_","LMEresults",".csv",sep="")
    outtablefname<-paste(outdir, fname, sep="/")
    write.table(outstats, outtablefname, sep = ",", row.names = FALSE)
    
}