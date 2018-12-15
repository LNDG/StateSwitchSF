lme_Behavanalysis <- function(tablefname) {
  
  library("nlme")
  library("dplyr")  
  library("lme4")
  
  COVARS=cbind("ID","Load")
  
  outdir<-dirname(tablefname)
  
  data<-read.table(tablefname,header = T, sep = ",")
  VAR=colnames(data[3])
  
  #data$AgeGrp[1:368]<-1
  #data$AgeGrp[173:368]<-2
  
  dataCOVARS=select(data,COVARS)
  
  VARmatch<-which(names(data)==VAR)
  
  newdat<-cbind(data[,VARmatch],dataCOVARS)
  names(newdat)[1]<-"y"
  
  lmermdl<-lmer(y ~ Load + (1|ID), newdat)
  
  #conf<-confint(lmerInt, method="boot", nsim=5000)
  
  out<-summary(lmermdl)
    
    fixedcoeffs<-as.data.frame(out$coefficients)
    
    npreds<-length(row.names(fixedcoeffs))
    outstats<-matrix(, nrow = as.numeric(npreds), ncol = 7)
    
      outstats[1,1]<-row.names(fixedcoeffs)[2]
    
    anovaout<-anova(lmer)
    
    outstats[,2:7]<-c(out$coefficients[2,], anovaout[,2],anovaout[,3],anovaout[,4])
    #outstats[,6:7]<-conf[3:length(conf[,1]),1:2]
    
    outstats<-as.data.frame(outstats)
    names(outstats)<-c("Predictor","Estimate","df","F","p")
    
    fname<-paste(VAR,"_","LMEresults",".csv",sep="")
    outtablefname<-paste(outdir, fname, sep="/")
    write.table(outstats, outtablefname, sep = ",", row.names = FALSE)
    
    #write random effects
    fname<-paste(VAR,"_","LMErfs",".csv",sep="")
    outfname<-paste(outdir, fname, sep="/")
    write.table(ranef(lmermdl)$ID[,2], outfname, sep = ",", row.names = FALSE, col.names = FALSE)
    
    #plot
#    newdat <- expand.grid(AgeGrp=unique(data$AgeGrp),Load=c(min(data$Load),max(data$Load)))
    
#    library(ggplot2)
#    ggplot(data, aes(x=Load, y=ACCLoadmean, colour=AgeGrp)) + geom_point(size=3) + geom_line(aes(y=predict(lmer), group=ID)) + geom_line(data=newdat, aes(y=predict(lmer, level=0, newdata=newdat)))
    
}