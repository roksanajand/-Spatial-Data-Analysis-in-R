install.packages("sf")       # Obsługa danych przestrzennych
install.packages("readxl")   # Wczytywanie danych Excel (XLSX)
install.packages("dplyr")    # Operacje na danych, jeśli potrzebne

library(sf)

#wczytuje dane 
punkty <- st_read("C:/Users/Dell/OneDrive/Pulpit/studia/V_SEM/ADP/zaj5/zaj5/zestaw2_XYTableToPoi_Project.shp")
osiedle<-st_read("C:/Users/Dell/OneDrive/Pulpit/studia/V_SEM/ADP/zaj5/zaj5/osiedla.shp")
library(ggplot2)
coordinates_punkty <- st_coordinates(punkty)

plot(osiedle$geometry,main = "Mapa wykroczeń na tle granic osiedli w Krakowie", 
     col = NA, border = "black", asp = 1, xlab = "X", ylab = "Y")
points(coordinates_punkty[, 1], coordinates_punkty[, 2], col = "red", pch = 19, cex = 0.3)
axis(1)  # oś X
axis(2)  # o Y



#dbscan
install.packages("dbscan")
library(dbscan)
library(spatstat)
mean(kNNdistplot(coordinates_punkty, k = 4))

# Ustal zakres (okno) współrzędnych dla punktów
minPts_values <- 3:15  # Przykładowe wartości minPts od 1 do 10
mean_distances <- numeric(length(minPts_values))

# Obliczanie średniej odległości do k-tego najbliższego sąsiada dla każdej wartości minPts
for (i in seq_along(minPts_values)) {
  k <- minPts_values[i]
  distances <- kNNdist(coordinates_punkty, k = k)
  mean_distances[i] <- mean(distances)
  cat("minPts =", k, "-> eps =", mean_distances[i], "\n")
  
}

# Tworzenie ramki danych dla wykresu
df <- data.frame(minPts = minPts_values, eps = mean_distances)
plot(df$minPts, df$eps, type = "b", pch = 19, col = "blue", 
     xlab = "minPts", ylab = "promień otoczenia (średnia odległość do k-tego sąsiada)",
     main = "Wykres zależności między minPts a eps")



eps_values <- c(200, 330, 220, 320,250,340)  #przyjmuje losowe wartości eps
minPts_values <- c(4, 4, 5,5,6,6)  # różne wartości minPts

punkty1<-punkty
par(mfrow = c(2, 3))

#będę wykonywać klasteryzacje dla różnych wartości eps i minPts  i rysować wykresy


#będę wykonywać klasteryzacje dla różnych wartości eps i minPts  i rysować wykresy
for (i in 1:6) {
  eps1 <- eps_values[i]
  minPts1 <- minPts_values[i]
  
  dbscan_result <- dbscan(st_coordinates(punkty1), eps = eps1, minPts = minPts1)
  
  #przypisuje wyniki klasteryzacji do danych jako nowa kolumna
  punkty1$cluster <- dbscan_result$cluster
  
  unique_clusters <- sort(unique(punkty1$cluster)) #wydrębniam unikalneklastry i je sortuje
  num_clusters <- length(unique_clusters) #ilość klastrów
  cluster_colors <- c("black", rainbow(num_clusters - 1)) #kolory, pierwszy szum jest czarny
  
  #rysuje osiedla
  plot(st_geometry(osiedle), col = "lightblue", border = "black", 
       main = paste("DBSCAN z eps =", eps1, "i minPts =", minPts1))
  
  #rysuje klastry
  plot(st_geometry(punkty1), col = cluster_colors[as.numeric(factor(punkty1$cluster))], 
       add = TRUE, pch = 20)
  
  #osie
  axis(1)
  axis(2)
}
# Resetowanie ustawień graficznych do domyślnych
par(mfrow = c(1, 1))



########hdbscan 
minPts_values_2 <- c(2,3,4, 9,15,25)  # 
punkty2<-punkty

par(mfrow = c(2, 3))

# Iteracja po wartościach eps i minPts, aby wykonać klasteryzację i narysować wykresy
for (i in 1:6) {
  # Wybór wartości eps i minPts
  minPts2 <- minPts_values_2[i]
  
  
  hdbscan_result <- hdbscan(st_coordinates(punkty2), minPts = minPts2)
  
  # Przypisanie wyników klasteryzacji do danych
  punkty2$cluster <- hdbscan_result$cluster
  
  # Ustalanie unikalnych klastrów i przypisanie kolorów
  unique_clusters <- sort(unique(punkty2$cluster))
  num_clusters <- length(unique_clusters)
  cluster_colors <- c("black", rainbow(num_clusters - 1))
  
  # Rysowanie granic osiedli
  plot(st_geometry(osiedle), col = "lightblue", border = "black", 
       main = paste("HDBSCAN z  minPts =", minPts2))
  
  # Rysowanie punktów z klastrami
  plot(st_geometry(punkty2), col = cluster_colors[as.numeric(factor(punkty2$cluster))], 
       add = TRUE, pch = 20)
  
  
  # Dodanie osi X i Y
  axis(1)
  axis(2)
}

# Resetowanie ustawień graficznych do domyślnych
par(mfrow = c(1, 1))



####################DRUGA OPCJA

# Ustawienie układu wykresów na 2x3 (dla 6 wykresów)
par(mfrow = c(2, 3))

# Iteracja po wartościach minPts, aby wykonać klasteryzację i narysować wykresy
for (i in 1:6) {
  # Wybór wartości minPts
  minPts2 <- minPts_values_2[i]
  
  # Klasteryzacja HDBSCAN
  hdbscan_result <- hdbscan(st_coordinates(punkty2), minPts = minPts2)
  hdbscan_result
  
  # Przypisanie wyników klasteryzacji do danych
  punkty2$cluster <- hdbscan_result$cluster
  
  # Rysowanie granic osiedli
  plot(st_geometry(osiedle), col = "lightblue", border = "black", 
       main = paste("HDBSCAN z minPts =", minPts2))
  
  # Rysowanie punktów z klastrami (zachowanie oryginalnej linii kodu)
  plot(st_geometry(punkty2), col = hdbscan_result$cluster + 1, 
       add = TRUE, pch = 20)
  
  # Przygotowanie legendy
  unique_clusters <- sort(unique(hdbscan_result$cluster))
  legend_colors <- unique_clusters + 1  # Przesuwamy kolory o 1, aby klaster 0 był szary
  legend_labels <- as.character(unique_clusters)
  
  # Dodanie legendy
  legend("topright", legend = legend_labels, col = legend_colors, pch = 20, title = "Klastry")
  
  # Dodanie osi X i Y
  axis(1)
  axis(2)
}

# Resetowanie ustawień graficznych do domyślnych
par(mfrow = c(1, 1))


