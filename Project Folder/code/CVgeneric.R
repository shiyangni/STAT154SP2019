#' @title CVgeneric
#' @description A generic function that takes in a training set(label, features), a loss function,
#' a model, and performs K-fold validation across the training set. Folds are created using random
#' sampling without replacement. 
#' 
#' train_labels and train_features are assumed to be in tidy format with mathcing number of rows. 
#' 
#' model should be passable into R's built in predict function to generate prediction. 
#' 
#' loss function should take in both true labels and estimated labels, and returns an error.
#' 
#' Notice we are assuming the labels are named "expert_label".
#' 
#' Further Notice we assume the two classes are encoded 0 and 1.
#' 
#' @return A list of three: Loss for each fold, Average Loss, and Time consumed for validation.

CVgeneric = function(features, labels, Model, loss, K){
  require(dplyr)
  row.names(features) = 1:nrow(features)
  names(labels) =  1:length(labels)
  raw_sample_size = nrow(features)
  ##Assuming K small and sample-size large, minor trimming should be fine.
  n = raw_sample_size - raw_sample_size %% K
  fold_size = n / K
  shuffled_indices = sample(1:n,n, replace = FALSE)
  fold_belonging = rep(1:K, each = fold_size)
  ##Book keeping
  fold_error = rep(0, K)
  names(fold_error) = paste("Error for fold", seq(1,K))
  ##Time Recording
  time_start = Sys.time()
  for(i in 1:K){
    ##Book keeping.
    val_index = shuffled_indices[fold_belonging == i]
    val_features = features[val_index, ]
    val_labels = labels[val_index]
    train_features = features[-val_index, ]
    train_labels = labels[-val_index]
    train = cbind(train_labels,train_features)
    val = cbind(val_labels, val_features)
    names(train)[1] = "expert_label"
    names(val)[1] = "expert_label"
    ##Intelligently using R's built in method. Wahahahaha.
    updated_model = update(Model, data = train)
    prediction = predict(updated_model, newdata = val, type = "response")
    ##Data type stuff. This part for R's built in Logistics Regression prediction.
    if(!is.list(prediction)){
      names(prediction) = NULL
      predicted_labels = prediction
      predicted_labels[prediction > 0.5] = 1
      predicted_labels[prediction <= 0.5] = 0
    }
    ##This part for RDA model in package klaR.
    else if(is.list(prediction) & (length(c) == 2)){
      predicted_labels = prediction$class
    }
    fold_error[i] = loss(predicted_labels, val_labels)
  }
  time_end = Sys.time()  
  average_error_across_fold = mean(fold_error)
  result = list(FoldLoss = fold_error, AveLoss = average_error_across_fold, 
                TimeElapsed = (time_end - time_start))
  return(result)
}


CVgeneric_cloud = function(train, Model, loss, K){
  labels = train[,"expert_label"]
  features = train[, which(names(train) != "expert_label")]
  return(CVgeneric(features, labels, Model, loss, K))
}

CVSet_nonrandom = function(Model){
  updated_model = update(Model, data = train_nonrandom)
  val_labels = val_nonrandom[,"expert_label"]
  prediction = predict(updated_model, newdata = val_nonrandom, type = "response")
  if(!is.list(prediction)){
    names(prediction) = NULL
    predicted_labels = prediction
    predicted_labels[prediction > 0.5] = 1
    predicted_labels[prediction <= 0.5] = 0
  }
  ##This part for RDA model in package klaR.
  else if(is.list(prediction) & (length(c) == 2)){
    predicted_labels = prediction$class
  }
  CVset_error = classification_error(predicted_labels, val_labels)
  return(CVset_error)
}


CVSet_random = function(Model){
  updated_model = update(Model, data = train_random)
  val_labels = val_random[,"expert_label"]
  prediction = predict(updated_model, newdata = val_random, type = "response")
  if(!is.list(prediction)){
    names(prediction) = NULL
    predicted_labels = prediction
    predicted_labels[prediction > 0.5] = 1
    predicted_labels[prediction <= 0.5] = 0
  }
  ##This part for RDA model in package klaR.
  else if(is.list(prediction) & (length(c) == 2)){
    predicted_labels = prediction$class
  }
  CVset_error = classification_error(predicted_labels, val_labels)
  return(CVset_error)
}


classification_error = function(true, predicted){
  return(mean(true != predicted))
}




image1_confident_logiModify = image1_confident
image1_confident_logiModify$expert_label[which(image1_confident_logiModify$expert_label == -1)] = 0
image1_confident_logiModify$expert_label %>% table()

m1 = glm(expert_label ~ CORR+NDAI+SD, data = image1_confident_logiModify, family = binomial)

image2_confident_logiModify = image2_confident
image2_confident_logiModify$expert_label[which(image2_confident_logiModify$expert_label == -1)] = 0
image2_confident_logiModify$expert_label %>% table()
# 
# m2 = update(m1, data = image2_confident_logiModify)
# m2_pred = predict(m2, newdata = image1_confident_logiModify[1:10, ], type = "response")
# length(m2_pred)
# nrow(image1_confident_logiModify[1:10, ])
# 
# a = image1_confident_logiModify[,-3]
# b = image1_confident_logiModify[,3]
# 
# dim(a)
# length(b)
# 
# 
# ##Running the function by hand
# K = 5
# raw_sample_size = nrow(a)
# n = raw_sample_size - raw_sample_size %% K
# fold_size = n / K
# shuffled_indices = sample(1:n, n, replace = FALSE)
# fold_belonging = rep(1:K, each = fold_size)
# 
# val_index = shuffled_indices[fold_belonging == 4]
# val_features = a[val_index, ]
# val_labels = b[val_index]
# dim(val_features)
# length(val_labels)
# 
# train_features = a[-val_index, ]
# train_labels = b[-val_index]
# dim(train_features)
# length(train_labels)
# 
# train = cbind(train_labels,train_features)
# val = cbind(val_labels, val_features)
# names(train)[1] = "expert_label"
# names(val)[1] = "expert_label"
# dim(train)
# dim(val)
# names(train)
# names(val)
# 
# updated_model = update(m1, data = train)
# prediction = predict(updated_model, newdata = val, type = "response")
# names(prediction) = NULL
# prediction[1:10]
# predicted_labels = prediction
# predicted_labels[prediction > 0.5] = 1
# predicted_labels[prediction <= 0.5] = 0
# mean(predicted_labels != val_labels)


##Testing

CVgeneric(a, b, m1, classification_error, 10)


##Does it work on LDA?
library(klaR)
lda_m1 = rda(expert_label ~ CORR+NDAI+SD, data = image1_confident_logiModify, gamma = 0, lambda = 1, CV=FALSE)
update(lda_m1, data = image2_confident_logiModify)
c = predict(lda_m1, newdata = image1_confident_logiModify, type = "response")
length(c)
c$class
CVgeneric(a, b, lda_m1, classification_error, 10)

