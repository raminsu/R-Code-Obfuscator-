#remove environment variables
rm(list=ls())

#load the required libraries
library(sodium)
library(stringi)
library(readr)

#environment variable for working directory 
Sys.setenv(wd = "E:/rprojects/eed")

#assign environment variable as working directory 
currentdirectory <-  Sys.getenv(x = "wd", unset = "", names = NA)
setwd(currentdirectory)

#declare function decrypt - which decrypts the R code and sources it 
decryptandrun <- function(filepathofencryptedfile, filepathofdecryptedfile, key, nonce){
  dataencrypted <- read_file_raw(filepathofencryptedfile)
  dataafterdecrypt <-  unserialize(data_decrypt(dataencrypted, key = key, nonce = nonce))
  dataafterdecrypt <- as.vector(dataafterdecrypt)
  write(dataafterdecrypt, filepathofdecryptedfile)
  source(filepathofdecryptedfile, local = TRUE)
}

#declare function encrypt - which encrypts the R code and write it to filepath location 
encrypt <- function(filesourcepath, filepath, key, nonce, noncechar){
  filecontent <- read_file(filesourcepath)
  sfilecontent <- serialize(filecontent, NULL)
  filecontent <- data_encrypt(sfilecontent, key, nonce)
  filecontent <- as.vector(filecontent)
  writeBin(filecontent, filepath)
}

obfuscator <- function(){

#declare variables 
filepathofencryptedfile <-  paste(getwd(), "/initializer1.txt", sep = "") 
filepathofdecryptedfile <- paste(getwd(), "/initializer1hidden.txt", sep = "") 

#declare key and nonce for initializer one 
key <- hash(charToRaw(toString(as.character("this is a key"), width = NULL )))
nonce <- charToRaw(substring("A nonce of length twenty four", 1,24))

#execute function decryptandrun for initializer one 
decryptandrun(filepathofencryptedfile, filepathofdecryptedfile, key, nonce)
  
}

#run the obfuscator, when core.R finishes execution a time stamp is stored at give location 
obfuscator()
