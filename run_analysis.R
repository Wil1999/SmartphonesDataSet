## Primeros pasos
## Descomprimimos el archivo donde se encuentran los datos
unzip("dataset.zip")

## Ordenamos los datos
## Datos de prueba
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
subTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Datos de entrenamiento
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
subTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Actividad y funciones
feat <- read.table("UCI HAR Dataset/features.txt")
act <- read.table("UCI HAR Dataset/activity_labels.txt")


## 1) Fusionar el datasets de prueba y entrenamiento
XPart <- rbind(testX,trainX)
YPart <- rbind(testY,trainY)
sub <- rbind(subTest,subTrain)

## 2) Extraer la media y desviacion estandar de cada medicion
##    Obtenemos las indices de las funciones que contienen mean() y std()
id <- grep("mean\\(\\)|std\\(\\)", feat[,2])
##    Obtenemos solo la media y desviacion estandar
XPart <- XPart[,id]

## 3) Utiliza nombre descriptivos para nombrar las actividades del dataset
##    Reemplazamos los valores numericos
YPart[,1] <- act[YPart[,1],2]

## 4) Etiquetar apropiadamente el dataset con descripcion de variables
##    Obtenemos nombres
nom <- feat[id,2]
##    Actualizar los nombres del dataset
names(XPart)<- nom
names(sub) <- "Sub_ID"
names(YPart) <- "Activity"
##    Fusionamos los datasets 
DCleaned <- cbind(sub,YPart,XPart)

## 5) A partir del paso 4, crear un segundo dataset ordenado independiente con el promedio
##    Formalizamos el dataset que tenemos
DCleaned <- data.table::data.table(DCleaned)
##    Hallamos los promedios respectivos
DTidy <- DCleaned[,lapply(.SD,mean),by ='Sub_ID,Activity']

##  We created "DTidy.txt"
write.table(DTidy,"Dtidy.txt",row.names = FALSE)
