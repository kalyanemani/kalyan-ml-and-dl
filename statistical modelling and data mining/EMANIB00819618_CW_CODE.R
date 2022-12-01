library(tidyverse)
library(MASS)
library(car)
library(e1071)
library(caret)
library(cowplot)
library(caTools)
library(pROC)
library(ggcorrplot)
#ADD THE PATH OF THE CSV FILE LOCATION
tel <- read.csv("/Users/KALYAN/Downloads/WAT.csv")
glimpse(tel)
options(repr.plot.width = 7, repr.plot.height = 5)
missingdata <- tel %>% summarise_all(funs(sum(is.na(.))/n()))
missingdata <- gather(missingdata, key = "variables", value = "percenmissing")
ggplot(missingdata, aes(x = reorder(variables, percenmissing), y = percenmissing))+
  geom_bar(stat = "identity", fill = "blue", aes(color = I('white')), size = 0.4)+
  xlab('variables')+
  coord_flip()+
  theme_bw()
tel <- tel[complete.cases(tel),]
tel$Seniorcitizens <- as.factor(ifelse(tel$Seniorcitizens==1, 'YES', 'NO'))
theme1 <- theme_bw()+
  theme(axis.text.x = element_text(angle = 0, hjust = 2, vjust = 0.6), legend.position="none")
theme2 <-theme_bw()
theme(axis.text.x = element_text(angle = 90, hjust = 2, vjust = 0.6), legend.position="none")
glimpse(tel)
options(repr.plot.width = 7, repr.plot.height = 5)
tel %>%
  group_by(chu) %>%
  summarise(Count = n())%>%
  mutate(percent = prop.table(Count)*100)%>%
  ggplot(aes(reorder(chu, -percent), percent), fill = chu)+
  geom_col(fill = c("#FC4E09", "#E7B807"))+
  geom_text(aes(label = sprintf("%.3f%%", percent)), hjust = 0.02,vjust = -0.6, size =4)+
  theme_bw()+
  xlab("chu")+
  ylab("percent")+
  ggtitle("chu percent")
options(repr.plot.width = 13, repr.plot.height = 9)
plot_grid(ggplot(tel, aes(x=gen,fill=chu))+ geom_bar()+theme2,
          ggplot(tel, aes(x=Seniorcitizens,fill=chu))+ geom_bar(position = 'fill')+theme2,
          ggplot(tel, aes(x=partners,fill=chu))+ geom_bar(position = 'fill')+theme2,
          ggplot(tel, aes(x=dependent,fill=chu))+ geom_bar(position = 'fill')+theme1,
          ggplot(tel, aes(x=phoneServices,fill=chu))+ geom_bar(position = 'fill')+theme2,
          ggplot(tel, aes(x=multipleline, fill=chu))+ geom_bar(position = 'fill')+theme_bw()+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          align = "h")
options(repr.plot.width = 13, repr.plot.height = 9)
plot_grid(ggplot(tel, aes(x=Internetservices,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=OnlineSecurity,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=onlinebackups,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=deviceprotections,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=techsupporting,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=streamingTVs,fill=chu))+ geom_bar(position = 'fill')+theme_bw()+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          align = "h")
plot_grid(ggplot(tel, aes(x=StreamingMovies,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=contracts,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=paperlessbillings,fill=chu))+ geom_bar(position = 'fill')+theme2+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          ggplot(tel, aes(x=paymentmethods,fill=chu))+ geom_bar(position = 'fill')+theme_bw()+
            scale_x_discrete(labels = function(x) str_wrap(x, width = 9)),
          align = "h")
options(repr.plot.width = 7, repr.plot.height = 3)
ggplot(tel, aes(y= Tenures, x = "", fill = chu))+
  geom_boxplot()+
  theme_bw()+
  xlab(" ")
ggplot(tel, aes(y= monthlycharge, x = "", fill = chu))+
  geom_boxplot()+
  theme_bw()+
  xlab(" ")
ggplot(tel, aes(y= totalCharge, x = "", fill = chu))+
  geom_boxplot()+
  theme_bw()+
  xlab(" ")
options(repr.plot.width = 7, repr.plot.height = 3)
tel_cor <- round(cor(tel[,c("Tenures", "monthlycharge", "totalCharge")]), 1)
ggcorrplot(tel_cor, title = "Correlation")+theme(plot.title = element_text(hjust = 0.6))
options(repr.plot.width = 6, repr.plot.height = 6)
boxplot(tel$Tenures)$out
boxplot(tel$monthlycharge)$out
boxplot(tel$totalCharge)$out
tel <- data.frame(lapply(tel, function(x) {
  gsub("No internet service", "No", x)}))
                
tel <- data.frame(lapply(tel, function(x) {
  gsub("No phone service", "No", x)}))
numb_columns <-c("Tenures", "monthlycharge", "totalCharge")
tel[numb_columns] <-sapply(tel[numb_columns], as.numeric)

tel_int <- tel[,c("Tenures", "monthlycharge", "totalCharge")]
tel_int <- data.frame(scale(tel_int))
tel <- mutate(tel, Tenures_bin = Tenures)
tel$Tenures_bin[tel$Tenures_bin >=0 & tel$Tenures_bin <= 13] <-'0-1 year'
tel$Tenures_bin[tel$Tenures_bin >=13 & tel$Tenures_bin <= 26] <-'1-2 years'
tel$Tenures_bin[tel$Tenures_bin >=26 & tel$Tenures_bin <= 39] <-'2-3 years'
tel$Tenures_bin[tel$Tenures_bin >=39 & tel$Tenures_bin <= 52] <-'3-4 years'
tel$Tenures_bin[tel$Tenures_bin >=52 & tel$Tenures_bin <= 65] <-'4-5 years'
tel$Tenures_bin[tel$Tenures_bin >=65 & tel$Tenures_bin <= 78] <-'5-6 years'
tel$Tenures_bin <- as.factor(tel$Tenures_bin)
options(repr.plot.width = 7, repr.plot.height = 5)
ggplot(tel, aes(Tenures_bin, fill=Tenures_bin))+ geom_bar()+theme1
tel_cat <- tel[,-c(1,6,19,20)]
dumm<- data.frame(sapply(tel_cat,function(x) data.frame(model.matrix(~x-1,data =tel_cat))[,-1]))
head(dumm)
tel_final <- cbind(tel_int,dumm)
head(tel_final)
set.seed(124)
indices = sample.split(tel_final$chu, SplitRatio = 0.8)
train = tel_final[indices, ]
validation = tel_final[!(indices),]
model_11 = glm(chu ~ ., data =train, family = "binomial")
summary(model_11)
model_12<- stepAIC(model_11, direction="both")            
summary(model_12)          
vif(model_12)            
model_13 <-glm(formula = chu ~ Tenures + monthlycharge + Seniorcitizens +
                 partners + Internetservices.xFiber.optic + Internetservices.xNo +
                 OnlineSecurity + onlinebackups + techsupporting + streamingTVs + contracts.xOne.year + contracts.xTwo.year +
                 paperlessbillings + paymentmethods.xElectronic.check + Tenures_bin.x1.2.years +
                 Tenures_bin.x5.6.years, family = "binomial", data = train)
summary(model_13)
vif(model_13)
model_14 <-glm(formula = chu ~ Tenures + monthlycharge + Seniorcitizens +
                 partners + Internetservices.xFiber.optic + Internetservices.xNo +
                 OnlineSecurity + onlinebackups + techsupporting + contracts.xOne.year + contracts.xTwo.year +
                 paperlessbillings + paymentmethods.xElectronic.check + Tenures_bin.x1.2.years +
                 Tenures_bin.x5.6.years, family = "binomial", data = train)
summary(model_14)
vif(model_14)
final_model <- model_13
pred <- predict(final_model, type = "response", newdata = validation[,-52])
summary(pred)
validation$prob <- pred
pred_chu <- factor(ifelse(pred >= 0.51, "Yes", "No"))
actual_chu <- factor(ifelse(validation$chu==1, "Yes","No"))
table(actual_chu,pred_chu)
cutoff_chu <- factor(ifelse(pred >=0.51, "Yes", "No"))
confusion_final <- confusionMatrix(cutoff_chu, actual_chu, positive = "Yes")
accuracy <- confusion_final$overall[1]
sensitivity <- confusion_final$byClass[1]
specificity <- confusion_final$byClass[2]
accuracy
sensitivity
specificity
perform_fun <- function(cutoff)
{
  predicted_chu <- factor(ifelse(pred >= cutoff, "Yes", "No"))
  confusion <- confusionMatrix(predicted_chu, actual_chu, positive = "Yes")
  accuracy <- confusion$overall[1]
  sensitivity <- confusion$byClass[1]
  specificity <- confusion$byClass[2]
  out <- t(as.matrix(c(sensitivity, specificity, accuracy)))
  colnames(out) <- c("sensitivity", "specificity", "accuracy")
  return(out)
}
options(repr.plot.width =9, repr.plot.height =7)
summary(pred)
s = seq(0.01,0.80,length=100)
OUT = matrix(0,100,3)
for(i in 1:100)
{
  OUT[i,] = perform_fun(s[i])
  
}
plot(s, OUT[,1],xlab="Cutoff",ylab="Value",cex.lab=1.6,cex.axis=1.6,ylim=c(0,1),
     type="l",lwd=2,axes=FALSE,col=2)
axis(1,seq(0,1,length=6),seq(0,1,length=6),cex.lab=1.6)
axis(2,seq(0,1,length=6),seq(0,1,length=6),cex.lab=1.6)
lines(s, OUT[,2],col="darkgreen",lwd=2)
lines(s, OUT[,3],col=4,lwd=2)
box()
legend("bottom",col=c(2,"green",4,"red"),text.font =4,inset = 0.03,
       box.lty=0,cex = 0.8,
       lwd=c(2,2,2,2),c("sensitivity","specificity","Accuracy"))
abline(v = 0.33, col="red", lwd=1, lty=2)
axis(1, at = seq(0.1, 1, by = 0.1))
cutoff_chu <- factor(ifelse(pred >=0.33, "Yes", "No"))
confusion_final <- confusionMatrix(cutoff_chu, actual_chu, positive = "Yes")
accuracy <- confusion_final$overall[1]
sensitivity <- confusion_final$byClass[1]
specificity <- confusion_final$byClass[2]
accuracy
sensitivity
specificity
set.seed(124)
tel_final$chu <-as.factor(tel_final$chu)
indices = sample.split(tel_final$chu, SplitRatio = 0.8)
train = tel_final[indices,]
validation = tel_final[!(indices),]
options(repr.plot.width =11, repr.plot.height =9)
library(rpart)
library(rpart.plot)
dtre = rpart(chu ~., data = train, method = "class")
summary(dtre)
print(dtre)
rpart.plot(dtre)
tpred <- predict(dtre,type = "class", newdata = validation[-52])
print(tpred)
plot(tpred)
confusionMatrix(validation$chu, tpred)
library(randomForest)
set.seed(124)
tel_final$chu <- as.factor(tel_final$chu)
indices = sample.split(tel_final$chu, SplitRatio = 0.8)
train = tel_final[indices,]
validation = tel_final[!(indices),]
model.r <- randomForest(chu ~ ., data=train, proximity=FALSE,importance = FALSE,
                         ntree=501,mtry=4, do.trace=FALSE)
model.r
summary(model.r)
print(model.r)
plot(model.r)
testPred <- predict(model.r, newdata=validation[,-52])
table(testPred, validation$chu)
confusionMatrix(validation$chu, testPred)
varImpPlot(model.r)
options(repr.plot.width =11, repr.plot.height =7)
glm.roc <- roc(response = validation$chu, predictor = as.numeric(pred))
t.roc <- roc(response = validation$chu, predictor = as.numeric(tpred))
r.roc <- roc(response = validation$chu, predictor = as.numeric(testPred))
plot(glm.roc,    legacy.axes = TRUE, print.auc.y = 1.0, print.auc = TRUE)
plot(t.roc, col = "darkblue", add = TRUE, print.auc.y = 0.66, print.auc = TRUE)
plot(r.roc, col = "darkred", add = TRUE, print.auc.y = 0.86, print.auc = TRUE)
legend("bottom", c("Random Forest", "Decision Tree", "Logistic"),
       lty = c(1,1), lwd = c(2,2), col = c("darkred", "darkblue", "black"), cex = 0.76)

