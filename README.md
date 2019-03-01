
<!-- README.md is generated from README.Rmd. Please edit that file -->

# yg

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

[![CRAN
status](https://www.r-pkg.org/badges/version/yg)](https://cran.r-project.org/package=yg)

The yg r package read yeast grower ini-formatted text
files.

## Installation

<!-- You can install the released version of yg from [CRAN](https://CRAN.R-project.org) with: -->

``` r
install.packages("yg") # not yet.
remotes::install_github("npjc/yg")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(yg)
path <- yg_example('05_09_13_RT1-79_ps1_A_96_T_13.txt')
d <- read_yg(path)
```

returns a nested tibble, with info and data sections.

**N.B. yg file names are prefixed with `dd_mm_yy_` and `read_yg()` uses
this information to compute the `datetime` variable in the data field**

``` r
str(d, 1)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  2 variables:
#>  $ info:List of 1
#>  $ data:List of 1
```

data variable has the measurement / growth data:

``` r
d$data[[1]]
#> # A tibble: 7,872 x 5
#>    datetime            runtime temperature well  measurement
#>    <dttm>                <dbl>       <dbl> <chr>       <dbl>
#>  1 2013-09-05 15:36:07     984        30.1 A01         0.116
#>  2 2013-09-05 15:50:52    1868        29.8 A01         0.121
#>  3 2013-09-05 16:05:30    2746        30   A01         0.126
#>  4 2013-09-05 16:20:06    3622        29.8 A01         0.122
#>  5 2013-09-05 16:34:42    4499        30   A01         0.117
#>  6 2013-09-05 16:49:19    5375        30   A01         0.122
#>  7 2013-09-05 17:03:56    6252        30   A01         0.124
#>  8 2013-09-05 17:18:32    7128        30   A01         0.119
#>  9 2013-09-05 17:33:08    8004        30   A01         0.120
#> 10 2013-09-05 17:47:44    8881        30   A01         0.118
#> # … with 7,862 more rows
```

info variable has other info:

``` r
dplyr::glimpse(d$info[[1]])
#> Observations: 1
#> Variables: 175
#> $ `last write`                 <chr> "\"14:01:22_14:09:11\""
#> $ file_origin                  <chr> "reconstructed_from_DB"
#> $ Comments                     <chr> "no%20comment"
#> $ Plate_Size                   <chr> "96"
#> $ Screen_Run_Type              <chr> "pre_screen_1"
#> $ run_ID                       <chr> "A"
#> $ Save_Data_File               <chr> "RT1-79"
#> $ run_plate_repeat             <chr> "1"
#> $ parent_id                    <chr> ""
#> $ Strain_Name                  <chr> ""
#> $ media_name                   <chr> "ypd"
#> $ drug_vol                     <chr> "2.00"
#> $ growth_params                <chr> "not_used"
#> $ user                         <chr> "jen_ubc"
#> $ Drug_Name                    <chr> ""
#> $ Quarter                      <chr> "A"
#> $ Units                        <chr> ""
#> $ Project_Name                 <chr> "misc"
#> $ Instrument                   <chr> "Tecan_13"
#> $ time_frm_freezer             <chr> "-1.00"
#> $ gens_frm_freezer             <chr> "-1.00"
#> $ Strain_Plate                 <chr> "none"
#> $ Drug_Plate                   <chr> "none"
#> $ drug_plate_dil_factor        <chr> "1.000000"
#> $ instrument_params            <chr> "not_used"
#> $ Ini_Names                    <chr> "Read_Reps,Delid,Save_Data_File,Sta…
#> $ Plate_Type                   <chr> "NUN96ft.pdf"
#> $ Samples_to_Run               <chr> "6"
#> $ Overlay_Size                 <chr> "48"
#> $ Plate_Quarter                <chr> "A"
#> $ Read_Reps                    <chr> "95"
#> $ Read_Modes                   <chr> "Absorbance"
#> $ Read_Flor_Every              <chr> "2"
#> $ Max_Delta_OD                 <chr> "0.500000"
#> $ Well_By_Row_Col              <chr> "none"
#> $ Reorder_Map                  <chr> "Order_Strings_Not,0"
#> $ Tip_Vol                      <chr> "200"
#> $ Save_Mix_Vol                 <chr> "0"
#> $ Save_Mix_Labware             <chr> "save_mix_pos_48"
#> $ Save_Mix_Reps                <chr> "0"
#> $ Add_Drug_Mix_Reps            <chr> "0"
#> $ OD_to_Innoc                  <chr> "0.100,0.100,0.380,0.380,0.380,0.38…
#> $ Absorption_Max               <chr> ".3"
#> $ OD_to_Save                   <chr> "0.100,0.100,0.380,0.380,0.380,0.38…
#> $ OD_to_Dilute                 <chr> "0.100"
#> $ Save_Sample_Vol              <chr> "180"
#> $ Save_Sample_Reps             <chr> "2"
#> $ Innoc_Vol                    <chr> "184,184,46,46,46,46,0,0,184,184,46…
#> $ Dilute_Vol                   <chr> "23,23,23,23,23,23,23,23,23,23,23,2…
#> $ Save_Vol                     <chr> "800,800,800,800,800,800,800,800,80…
#> $ Reference_Vol                <chr> "100,100,100,100,100,100,100,100,10…
#> $ Read_to_Innoc                <chr> "20,20,20,20,20,20,20,20,20,20,20,2…
#> $ Read_to_Dilute               <chr> "26,26,26,26,26,26,26,26,26,26,26,2…
#> $ Read_to_Save                 <chr> "20,20,20,20,20,20,20,20,20,20,20,2…
#> $ Innoc_Target_Map             <chr> "1,2,3,4,5,6,7,8,9,10,11,12,13,14,1…
#> $ Pipet_Trigger                <chr> "OD_Save_Innoc"
#> $ Pipet_Volume_Adj             <chr> "Con_OD_Save"
#> $ Delid                        <chr> "no"
#> $ Pre_Init                     <chr> "yes"
#> $ Talk_To_ProMax               <chr> "no"
#> $ Time_Out_Time                <chr> "1050"
#> $ Wait_While_Busy              <chr> "yes"
#> $ Idle_Time                    <chr> "2"
#> $ Spect_Protocol               <chr> "15m"
#> $ Spec_Run_File                <chr> "GG_PB_Voyage.pda"
#> $ Working_Dir                  <chr> "C%3AUsersGrowth_Data"
#> $ Run_Control_Dir              <chr> "C%3AUsersYeast_Run_Files"
#> $ Save_Run_Data_Flag           <chr> "yes"
#> $ Set_Incubator_Temp           <chr> "30.0"
#> $ Base_Line_Flag               <chr> "atstart_minimum"
#> $ Pipet_Cycles_Before_Save     <chr> "20"
#> $ Time_Point_Save              <chr> "wellmap"
#> $ Innoc_Direction              <chr> "down"
#> $ Wells_In_Use                 <chr> "1111111111111111111111111111111111…
#> $ Save_Sample_Map              <chr> "1111110011111100111111001111110011…
#> $ Sections_to_Run              <chr> "1"
#> $ Rows_per_Section             <chr> "8"
#> $ Start_Sections_Row           <chr> "1"
#> $ MultiProbe_Run_File          <chr> "MJP_Innoc_Save_Tecan_1_Falcon.MPT"
#> $ Multiprobe_Run_Dialogue      <chr> "yes"
#> $ Target_Temp                  <chr> "290"
#> $ Temp_Control                 <chr> "On"
#> $ Delta_Temp                   <chr> "10.0"
#> $ ReadMode                     <chr> "Absorbance,Top"
#> $ ExcitationFilter             <chr> "485"
#> $ EmissionFilter               <chr> "535"
#> $ MeasurementFilter            <chr> "595"
#> $ ReadsPerWellNumber           <chr> "1,1"
#> $ ShakeDuration                <chr> "800,0"
#> $ ShakeIntensity               <chr> "high"
#> $ GainMode                     <chr> "Manual"
#> $ PdfName                      <chr> "NUN96ft.pdf"
#> $ Gain                         <chr> "60"
#> $ Add_Drug_Map                 <chr> "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,…
#> $ Add_Drug_Vol                 <chr> "7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,…
#> $ Innoc_Map                    <chr> "1110111011101110111011101110111011…
#> $ Dilute_Map                   <chr> "1111111111111111111111111111111111…
#> $ data_file_name               <chr> "ps1_1_96.txt"
#> $ Hit_Call_Threshold           <chr> "0.46"
#> $ Reference_Well               <chr> "A01"
#> $ WT_Ref_Well                  <chr> "0"
#> $ Pipet_Gens_Point             <chr> "5.00,10.00,15.00,20.00,5.00,10.00,…
#> $ Shake_Divisor                <chr> "1"
#> $ data_handling                <chr> "file_&_DB_&_auto_analysis"
#> $ well_vol                     <chr> "100"
#> $ Save_Mode                    <chr> "one_to_one"
#> $ Consolidate_Save_Map         <chr> "1,2,3,4,5,6,7,8,9,10,11,12,13,14,1…
#> $ Add_Drug_at_Start_Map        <chr> "0000000000000000000000000000000000…
#> $ Add_Drug_Labware             <chr> "add_drug_48"
#> $ Max_Dynam_OD_Change          <chr> "0.05"
#> $ Reads_After_Pipet            <chr> "1"
#> $ Ref_Type                     <chr> "single_ref"
#> $ Read_to_Add_Drug_at_Start    <chr> "0"
#> $ Send_Email_at_Pipet          <chr> "send_email"
#> $ config_DB_update_wells       <chr> "yes"
#> $ OD_Gen_Pt_48                 <chr> "0.76"
#> $ Gens_to_OD_Pt_48             <chr> "5"
#> $ OD_Gen_Pt_96                 <chr> "0.46"
#> $ Gens_to_OD_Pt_96             <chr> "5.00"
#> $ OD_Gen_Pt_384                <chr> "0.460"
#> $ Gens_to_OD_Pt_384            <chr> "5.000"
#> $ OD_Gen_Pt_1536               <chr> "0.460"
#> $ Gens_to_OD_Pt_1536           <chr> "5.000"
#> $ Save_Pos_Labware             <chr> "save_pos_use_deck_map"
#> $ Save_Well_Convert_Row_Col    <chr> "not_set"
#> $ Orientation_allowed_error    <chr> "0.1"
#> $ Pipet_Trigger_Well_Map       <chr> "1,2,3,4,5,6,7,8,9,10,11,12,13,14,1…
#> $ Upload_Run_Data_Every        <chr> "10"
#> $ innoc_chk_change             <chr> "0.5"
#> $ save_chk_change              <chr> "0.3"
#> $ Media                        <chr> "ypd"
#> $ Drug_Conc                    <chr> "2"
#> $ Innoc_Conc                   <chr> "0.06250"
#> $ ShakeMode                    <chr> "Orbital"
#> $ NumberOfFlashes              <chr> "1"
#> $ PartOfPlate                  <chr> "0"
#> $ MovePlateOutAfterMeasurement <chr> "0"
#> $ IntegrationLagTime           <chr> "0"
#> $ IntegrationTime              <chr> "100"
#> $ DelayMoveFlashFluorescence   <chr> "0"
#> $ Strain_Pool                  <chr> "ho1"
#> $ OD_Gen_Pt_100                <chr> "0.206"
#> $ Gens_to_OD_Pt_100            <chr> "4"
#> $ ExcitationBandWidth          <chr> "20,20"
#> $ AbsorbanceBandWidth          <chr> "10,10"
#> $ EmisionBandWidth             <chr> "25,20"
#> $ diluent                      <chr> "dmso,dmso,dmso,dmso,dmso,dmso,dmso…
#> $ robot_name                   <chr> "Yeast_Grower_3"
#> $ Plate_ID                     <chr> "\"29202\""
#> $ growth_plate_id              <chr> "\"29202\""
#> $ Drug_Plate1                  <chr> "none"
#> $ Strain_Plate1                <chr> "none"
#> $ run_ID1                      <chr> "A"
#> $ run_plate_repeat1            <chr> "1"
#> $ Parent_ID                    <chr> ""
#> $ user1                        <chr> "elisa_ubc"
#> $ Project_Name1                <chr> "elisa_ubc"
#> $ media_name1                  <chr> "ypd"
#> $ Quarter1                     <chr> "A"
#> $ time_frm_freezer1            <chr> "-1"
#> $ gens_frm_freezer1            <chr> "-1"
#> $ drug_plate_dil_factor1       <chr> "1"
#> $ Well_Pos                     <chr> "1,2,3,4,5,6,7,8,9,10,11,12,13,14,1…
#> $ Well_Alias                   <chr> "A01,A02,A03,A04,A05,A06,A07,A08,A0…
#> $ Drug_Name1                   <chr> "nd,dmso,rt1-79,rt1-79,blank,blank,…
#> $ Drug_Conc1                   <chr> "0,2,100,0,0,0,0,0,0,0,0,0,0,2,50,0…
#> $ Units1                       <chr> "nd,%,mg/mL,,,,,,,,,,nd,%,mg/mL,,,,…
#> $ Drug_Vol                     <chr> ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,…
#> $ Strain_Pool1                 <chr> "by4743,blank,by4743,blank,blank,bl…
#> $ Innoc_Conc1                  <chr> "0.06250,0.06250,0.06250,0.06250,0.…
#> $ Strain_Backgrnd              <chr> "3,,3,,,,,,,,,,3,,3,,,,,,,,,,3,,3,,…
#> $ well_media                   <chr> "YPD,YPD,YPD,ypd,ypd,ypd,ypd,ypd,yp…
#> $ Well_Vol                     <chr> "100,100,100,100,100,100,100,100,10…
#> $ diluent1                     <chr> "dmso,dmso,dmso,dmso,dmso,dmso,dmso…
#> $ Condition                    <chr> "0,2,100,0,0,0,0,0,0,0,0,0,0,2,50,0…
```
