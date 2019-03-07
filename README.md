
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/readyg)](https://cran.r-project.org/package=readyg)

Read, Validate, Simulate and Write YeastGrower (aka ACCESS)
files.

## Installation

<!-- You can install the released version of yg from [CRAN](https://CRAN.R-project.org) with: -->

``` r
# install.packages("readyg") # not yet.
remotes::install_github("npjc/readyg")
```

## Example

Yeast Grower/ACCESS files are written in windows ini format (*sort-of*).
`read_yg()` parses this format and returns the data in a format suitable
for analysis or exporting (writing) to a `.csv` files.

``` r
library(readyg)
files <- yg_example_files()
files[1] # one example file
#> [1] "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/readyg/extdata/05_09_13_RT1-79_ps1_A_96_T_13.txt"
d <- read_yg(files[1])
d
#> # A tibble: 1 x 3
#>   data                 run_params         drug_data        
#>   <list>               <list>             <list>           
#> 1 <tibble [7,872 × 5]> <tibble [149 × 2]> <tibble [25 × 2]>
```

In the individual sections:

``` r
d$data
#> [[1]]
#> # A tibble: 7,872 x 5
#>    well  datetime            runtime value temperature
#>    <chr> <dttm>                <dbl> <dbl>       <dbl>
#>  1 A01   2013-09-05 15:36:07     984 0.116        30.1
#>  2 A01   2013-09-05 15:50:52    1868 0.121        29.8
#>  3 A01   2013-09-05 16:05:30    2746 0.126        30  
#>  4 A01   2013-09-05 16:20:06    3622 0.122        29.8
#>  5 A01   2013-09-05 16:34:42    4499 0.117        30  
#>  6 A01   2013-09-05 16:49:19    5375 0.122        30  
#>  7 A01   2013-09-05 17:03:56    6252 0.124        30  
#>  8 A01   2013-09-05 17:18:32    7128 0.119        30  
#>  9 A01   2013-09-05 17:33:08    8004 0.120        30  
#> 10 A01   2013-09-05 17:47:44    8881 0.118        30  
#> # … with 7,862 more rows
d$run_params
#> [[1]]
#> # A tibble: 149 x 2
#>    key              value                
#>    <chr>            <chr>                
#>  1 file_origin      reconstructed_from_DB
#>  2 Comments         no%20comment         
#>  3 Plate_Size       96                   
#>  4 Screen_Run_Type  pre_screen_1         
#>  5 run_ID           A                    
#>  6 Save_Data_File   RT1-79               
#>  7 run_plate_repeat 1                    
#>  8 parent_id        ""                   
#>  9 Strain_Name      ""                   
#> 10 media_name       ypd                  
#> # … with 139 more rows
d$drug_data
#> [[1]]
#> # A tibble: 25 x 2
#>    key              value    
#>    <chr>            <chr>    
#>  1 Drug_Plate       none     
#>  2 Strain_Plate     none     
#>  3 run_ID           A        
#>  4 run_plate_repeat 1        
#>  5 Parent_ID        ""       
#>  6 user             elisa_ubc
#>  7 Project_Name     elisa_ubc
#>  8 media_name       ypd      
#>  9 Quarter          A        
#> 10 time_frm_freezer -1       
#> # … with 15 more rows
```

If you want the information in the other sections , you can use
`read_ini()` instead. This parses the ini file into a list:

``` r
l <- read_ini(files[1])
str(l, 1)
#> List of 6
#>  $ config file info:List of 1
#>  $ Run_Parameters  :List of 149
#>  $ Runtime_State   :List of 34
#>  $ Drug_Data       :List of 25
#>  $ Analysis        :List of 92
#>  $ Data:           :List of 83
```

## Additional Info

YeastGrower/ACCESS encodes data in non-standard ways that `read_yg()`
corrects:

**data section:**

  - the temperature field may be written as `300`, `30`, `30.0` to
    indicate 30ºC.  
  - the datetime field in the data may be written as `D0_12:11:10`, `D0
    _12:11:10` or `12:11:10` to indicate 12:11:10 on the first day of
    the run. To indicate what date `D0` is you can provide this as an
    argument to e.g. `read_yg('path/to/file.txt', start_date =
    'YYYY-MM-DD')`.
      - N.B. if the datetime field is encoded as `12:11:10` and the run
        last longer that one day the current results may be erroneous.
        e.g. `12:11:10, ... , 23:48:17, ... , 00:12:34` would be encoded
        as the same day. This is the safe default but will provide an
        option to ‘fix’ this in the future.  
  - well field: The well field is encoded in row-major order
    (‘standard’) for 6,24,96, and 384 well plates but ACCESS uses a
    custom ordering for 48 well plates. Currently, we remap these to the
    standard arangement so that the wells names of a 48-well plate
    follow the standard convention.
      - N.B. the drug\_data section, if present, can contain a
        `Well_Alias` field which is currently not checked for this
        inconsistency. Handle with care if using this information.

**all the keys**

The Yeast Grower format has some use of nearly 3000 separte keys
(fields). To retrieve all of them:

``` r
yg_section_keys()
#> # A tibble: 2,979 x 2
#>    section          key               
#>    <chr>            <chr>             
#>  1 config file info last_write        
#>  2 config file info last write        
#>  3 Run_Parameters   Instrument        
#>  4 Run_Parameters   Ini_Names         
#>  5 Run_Parameters   barcode_drug_plate
#>  6 Run_Parameters   user              
#>  7 Run_Parameters   Plate_Size        
#>  8 Run_Parameters   Plate_Type        
#>  9 Run_Parameters   Samples_to_Run    
#> 10 Run_Parameters   Overlay_Size      
#> # … with 2,969 more rows
```
