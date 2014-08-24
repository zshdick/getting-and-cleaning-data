# First, read data from the txt file

  X <- rbind(read.table("train/X_train.txt"), read.table("test/X_test.txt"))
  S <- rbind(read.table("train/subject_train.txt"), read.table("test/subject_test.txt"))
  Y <- rbind(read.table("train/y_train.txt"), read.table("test/y_test.txt"))
  
# Extracts only the measurements on the mean and standard deviation for each measurement.
  
  features <- read.table("features.txt")
  ind <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
  X <- X[, ind]
  names(X) <- features[ind, 2]
  names(X) <- gsub("\\(|\\)", "", names(X))
  names(X) <- tolower(names(X)) 
  
  act <- read.table("activity_labels.txt")
  act[, 2] = gsub("_", "", tolower(as.character(act[, 2])))
  Y[,1] = act[Y[,1], 2]
  names(Y) <- "activity"
  
# clean the data
  
  names(S) <- "subject"
  cle <- cbind(S, Y, X)
  write.table(cle, "merged_clean_data.txt")
  
  uniqueSub = unique(S)[,1]
  numSub = length(unique(S)[,1])
  numAct = length(act[,1])
  numCols = dim(cle)[2]
  result = cle[1 : (numSub * numAct), ]
  
  row = 1
  for (s in 1:numSub) {
    for (a in 1:numAct) {
      result[row, 1] = uniqueSub[s]
      result[row, 2] = act[a, 2]
      tmp <- cle[cle$subject == s & cle$activity == act[a, 2], ]
      result[row, 3 : numCols] <- colMeans(tmp[, 3 : numCols])
      row = row + 1
    }
  }

  # Output the tidy data
  
  write.table(result, "tidy_data.txt")