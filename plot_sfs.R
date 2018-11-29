#!/usr/bin/Rscript
infile = commandArgs()[6]
x = read.table(infile, h=T, skip=1)

palette = colorRampPalette(c('#ffffd9','#edf8b1','#c7e9b4','#7fcdbb','#41b6c4','#1d91c0','#225ea8','#253494','#081d58'))
#palette2= colorRampPalette(c('#fff7f3','#fde0dd','#fcc5c0','#fa9fb5','#f768a1','#dd3497','#ae017e','#7a0177','#49006a'))

# pdf
outfile = strsplit(infile, ".", fixed=T)[[1]]
outfile = paste(paste(outfile[-length(outfile)], collapse="."), ".pdf", sep="")
pdf(outfile, bg="white")
par(las=1)
image(as.matrix(log10(x))[nrow(x):1,], col = palette(100), xlab = expression(f["species B"]), ylab = expression(f["species A"]), cex.axis=1.25, cex.lab=1.1)
dev.off()

# png
outfile = strsplit(infile, ".", fixed=T)[[1]]
outfile = paste(paste(outfile[-length(outfile)], collapse="."), ".png", sep="")
png(outfile, res=600, width=4.5, height=4.5, units='in')
par(las=1)
image(as.matrix(log10(x))[nrow(x):1,], col = palette(100), xlab = expression(f["species B"]), ylab = expression(f["species A"]), cex.axis=1.25, cex.lab=1.2)
dev.off()


