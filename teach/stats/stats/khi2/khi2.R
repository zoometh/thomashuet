
library(dplyr)
library(tibble)



df.copy <- df
df.copy <- rbind(df.copy, colSums(df.copy[ , -1]))
df.copy[nrow(df.copy), "patient"] <- "col.sum"
df.copy <- cbind(df.copy, rowSums(df.copy[ , -1]))
colnames(df.copy)[ncol(df.copy)] <- "row.sum"

total <- df.copy[nrow(df.copy), ncol(df.copy)]
df.copy2 <- df
for(i in seq(1, nrow(df))){
  for(j in seq(2, ncol(df))){
    col.sum <- sum(df.copy2[ , j])
    row.sum <- sum(df.copy2[ i, seq(2, ncol(df))])
    obs.val <- df.copy2[i, j]
    exp.val <- (col.sum * row.sum) / total
    df.copy2[i, j] <- exp.val
  }
}
df.copy2

df.copy3 <- df.copy2
for(i in seq(1, nrow(df))){
  for(j in seq(2, ncol(df))){
    obs.val <- df[i, j]
    exp.val <- df.copy2[ i, j]
    khi.val <- (obs.val-exp.val)**2 / exp.val
    df.copy3[i, j] <- khi.val
  }
}
df.copy3


df.copy4 <- melt(df.copy3, id.vars = "patient")
ggplot(df.copy4, aes(x = variable, y = value,
                     colour = patient, 
                     group = patient)) + 
  geom_hline(yintercept = 0) +
  geom_point() +
  geom_text(aes(label = value), vjust = 1) +
  geom_path() +
  theme_bw()

