# We create the 3d mds so we can export the x, y, z coordinates to a csv file.
# We import the csv file into the processing app.

library(vegan)
library(labdsv)
library(rgl) # for plot3d
#
sWD <- "/Users/matt/Documents/phase_space_06April2019/"
dir.create(sWD)

# Function declarations.
# Create a soldist file.
generate_phase <- function(iDim,phase0)
{
  iSize <- 2^iDim
  y <- c(rep(0,(iSize/2)),rep(1,(iSize/2)))
  x <- rbind(phase0,phase0)
  
  phaseX <- cbind(y,x)
  colnames(phaseX) <- paste0("p",rep(1:iDim))
  rownames(phaseX) <- paste0("r",rep(1:iSize))
  save(phaseX,file=paste0(sWD,"phase",iDim,".Rdata"))
  
  return(phaseX)
}
generate_2d <- function(sName,dist_mtx,iWidth=1000,iHeight=1000)
{
  mds_2d <- nmds(dist_mtx,2)
  save(dist_mtx,mds_2d,file=paste0(sWD,"mds_",sName,"_2d.Rdata"))
  
  png(filename=paste0(sWD,sName,"_2d.png"),width=iWidth,height=iHeight)
  plot(mds_2d$points, axes=F, xlab='', ylab='', type = "n", col="blue")
  points(mds_2d$points, col="blue", pch=19)
  dev.off()
}
generate_soldist <- function(iDim)
{
  load(file=paste0(sWD,"phase",iDim,".Rdata"))
  solX <- unique(phaseX)
  soldistX<-vegdist(solX,distance="jaccard")
  save(soldistX,file=paste0(sWD,"soldist_",iDim,".Rdata"))
}
generate_3d <- function(iDim)
{
  load(file=paste0(sWD,"soldist_",iDim,".Rdata"))
  mds_3d <- nmds(soldistX,3)
  save(mds_3d,file=paste0(sWD,"mds_",iDim,"_3d.Rdata"))
}
write_points_file <- function(sPointsFile,mds3d){
  write("x,y,z",file=sPointsFile,append=FALSE)
  for (i in 1:dim(mds3d$points)[1])
  {
    write(paste0(mds3d$points[i,1],',',mds3d$points[i,2],',',mds3d$points[i,3]),
          file=sPointsFile,append=TRUE)
  }
}

# generate 2d phase space
p2 <- rbind(c(0,0),
            c(0,1),
            c(1,0),
            c(1,1))
colnames(p2) <- c("p1","p2")
rownames(p2) <- c("r1","r2","r3","r4")
generate_2d("p2",vegdist(p2,distance="jaccard"))

# generate 3d to 14d phase spaces
p3 <- generate_phase(3,p2)
generate_2d("p3",vegdist(p3,distance="jaccard"))
p4 <- generate_phase(4,p3)
generate_2d("p4",vegdist(p4,distance="jaccard"))
p5 <- generate_phase(5,p4)
generate_2d("p5",vegdist(p5,distance="jaccard"))
p6 <- generate_phase(6,p5)
generate_2d("p6",vegdist(p6,distance="jaccard"))
p7 <- generate_phase(7,p6)
generate_2d("p7",vegdist(p7,distance="jaccard"))
p8 <- generate_phase(8,p7)
generate_2d("p8",vegdist(p8,distance="jaccard"))
p9 <- generate_phase(9,p8)
generate_2d("p9",vegdist(p9,distance="jaccard"))
p10 <- generate_phase(10,p9)
generate_2d("p10",vegdist(p10,distance="jaccard"))
# Note: above 10d, this is really slow and uses lots of memory
p11 <- generate_phase(11,p10)
generate_2d("p11",vegdist(p11,distance="jaccard"))
p12 <- generate_phase(12,p11)
generate_2d("p12",vegdist(p12,distance="jaccard"))
p13 <- generate_phase(13,p12)
generate_2d("p13",vegdist(p13,distance="jaccard"))
p14 <- generate_phase(14,p13)
generate_2d("p14",vegdist(p14,distance="jaccard"))

# generate 3d mappings for 3d to 14d phase spaces
for (i in 3:10)
{
  generate_soldist(i)
  generate_3d(i)
}
# Note: above 10d, this is really slow and uses lots of memory
for (i in 11:14)
{
  generate_soldist(i)
  generate_3d(i)
}

# create the points csv files
for (i in 3:10)
{
  load(paste0(sWD,"mds_",i,"_3d.Rdata"))
  write_points_file(paste0(sWD,i,".csv"),mds_3d)
}
# Note: above 10d, this is really slow and uses lots of memory
for (i in 11:14)
{
  load(paste0(sWD,"mds_",i,"_3d.Rdata"))
  write_points_file(paste0(sWD,i,".csv"),mds_3d)
}
