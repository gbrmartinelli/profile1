library(shiny)

# Define server logic for slider examples
shinyServer(function(input, output) {

  # Reactive expression to compose a data frame containing all of the values
  sliderValues <- reactive({

    # Compose data frame
    data.frame(
      Name = c("Integer", 
               "Decimal",
               "Range",
               "Custom Format",
               "Animation"),
      Value = as.character(c(input$integer, 
                             input$decimal,
                             paste(input$range, collapse=' '),
                             input$format,
                             input$animation)), 
      stringsAsFactors=FALSE)
  }) 

output$mainplot <- renderPlot({

sFractionPlateau=input$fractionPlateau
sInitialVolume=input$initialVolume
sFractionEOP=input$fractionEOP
sDeclineRate=input$declineRate
sPeakWellRate=input$peakWellRate
sWellPlateauFactor=input$wellPlateauFactor

#sFractionPlateau=0.1
#sInitialVolume=10
#sFractionEOP=0.5
#sDeclineRate=0.1
#sPeakWellRate=3.5
#sWellPlateauFactor=0

declineNominal=-log(1-sDeclineRate)
pwrYear=sPeakWellRate*0.36525
adjR=sFractionPlateau/declineNominal
initialVirtual=adjR+(1-sFractionEOP)
fieldDecline=adjR/initialVirtual
volFraction=1-sFractionEOP
pwrCalc=pwrYear/sInitialVolume
pwrUncost=pwrCalc/(1-sWellPlateauFactor)
wellRateEOP=min(pwrUncost*fieldDecline,pwrCalc)
reqNOW=sFractionPlateau/wellRateEOP
NOW=max(round(reqNOW),1)
reqWR=sFractionPlateau/NOW
fieldDeclinePlateau=reqWR/pwrUncost
vVolumePlateau=fieldDeclinePlateau*initialVirtual
volumeProducedEOP=initialVirtual-vVolumePlateau
volumeRemaining=1-volumeProducedEOP
timeLeavePlateau=volumeProducedEOP/sFractionPlateau
maxRecRate=min(initialVirtual,1)
effDallWells=NOW*pwrUncost/initialVirtual
timeEOPuncost=log(initialVirtual/vVolumePlateau)/effDallWells
plateauDelay=timeLeavePlateau-timeEOPuncost

year=seq(0,29)
fvt=rep(NaN,30)
ft=rep(NaN,30)
rt=rep(NaN,30)
ryear=rep(NaN,30)
Deff=rep(NaN,30)
Dnom=rep(NaN,30)

fvt[1]=initialVirtual
for (i in seq(2,30)){
if (year[i]>timeLeavePlateau){
fvt[i]=initialVirtual*exp(-effDallWells*(year[i]-plateauDelay))
} else {
fvt[i]=fvt[i-1]-sFractionPlateau
}
}

for (i in seq(1,30)){
ft[i]=max(1-(initialVirtual-fvt[i]),0)
rt[i]=ft[i]*sInitialVolume
if (i>1) { ryear[i]=rt[i-1]-rt[i]}
}

names(ryear)=year

barplot(ryear[2:30], main=paste("Profile, nwells=",NOW),xlab="year",ylab="Produced per year")

#plot(input$initialVolume,input$fractionPlateau)

})
  # Show the values using an HTML table
#  output$values <- renderTable({
#    sliderValues()
#  })
})