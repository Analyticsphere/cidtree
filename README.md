# cidtree
Jake Peters
2024-04-01

- [Introductiondd](#introductiondd)
- [Examples](#examples)
  - [Install `cidtree`](#install-cidtree)
  - [Construct and visualize a data dictionary
    tree](#construct-and-visualize-a-data-dictionary-tree)
  - [View dictionary as a dataframe](#view-dictionary-as-a-dataframe)
  - [Retrieve a key, given a cid](#retrieve-a-key-given-a-cid)
  - [Retrieve a concept id, given a
    key](#retrieve-a-concept-id-given-a-key)
  - [Retrieve all metadata using the
    cid](#retrieve-all-metadata-using-the-cid)
  - [Retrieve all metadata using the
    cid](#retrieve-all-metadata-using-the-cid-1)
- [References](#references)

<!-- README.md is generated from README.Rmd. Please edit that file -->

## Introductiondd

The objectives of `cidtree` package are to

1.  construct a `data.tree` object from a data dictionary

2.  provide convenient functions to explore the data dictionary

3.  automate the mapping of Concept IDs to the associated concepts and
    metadata.

4.  map concepts to their counterparts in the cidtree GCP tables

I intend this to be a toolkit to standardize the way that analysts
interact with the Connect for Cancer Prevention data dictionary.

Here is the **documentation**:
<https://github.com/Analyticsphere/cidtree/blob/main/cidtree_docs.pdf>

## Examples

Load dependencies

``` r
library(dplyr)
library(data.tree)
library(jsonlite)
library(devtools)
```

### Install `cidtree`

**Option 1:** If you have cloned this repo and are working inside the
~/cidtree/ directory, use this:

``` r
devtools::load_all("./")
```

**Option 2:** If you want to install the library and load it like any
other library, use this:

``` r
devtools::install_github('Analyticsphere/cidtree')
library(cidtree)
```

### Construct and visualize a data dictionary tree

``` r
path <- "./data/test_dictionary"
dd <- cidtree::construct_dictionary_tree(path)
print(dd, 'concept_str')
```

                       levelName                                        concept_str
    1  0                         DICT: connect4cancer                              
    2   ¦--129084651              PRI_SRC: Survey                                  
    3   ¦   °--965707586           SEC_SRC: Smoking, Alcohol, and Sun Exposure     
    4   ¦       ¦--194557808          QUEST: SrvSAS_AgeCigsUseF_v1r0               
    5   ¦       ¦--790436165        SRC: Age first used cigarettes on a regular ...
    6   ¦       ¦   ¦--408696162      QUEST: SrvSAS_AgeCigsUseRegF_v1r0            
    7   ¦       ¦   °--965482317      QUEST: SrvSAS_NeverSmokedReg_v1r0            
    8   ¦       ¦--947205597        SRC: Have you ever used any of these tobacco...
    9   ¦       ¦   ¦--535003378      QUEST: SrvSAS_NoTobacco_v1r0                 
    10  ¦       ¦   ¦--686310465      QUEST: SrvSAS_TobaccoPipe_v1r0               
    11  ¦       ¦   °--712653855      QUEST: SrvSAS_Cigarettes_v1r0                
    12  ¦       ¦--639684251          QUEST: SrvSAS_UseCigsNow_v1r0                
    13  ¦       ¦--763164658          QUEST: SrvSAS_CigarettesLife_v1r0            
    14  ¦       °--798549704          QUEST: SrvSAS_UseCigsLast_v1r0               
    15  ¦--192505768              PRI_SRC: Recruitment                             
    16  ¦   °--214456996           SEC_SRC: Eligibility Screener                   
    17  ¦       ¦--142654897        SRC: How did you hear about this study? (Sel...
    18  ¦       ¦   ¦--461488577      QUEST: RcrtES_Aware_v1r0_Email               
    19  ¦       ¦   ¦--607081902      QUEST: RcrtES_Aware_v1r0_Invite              
    20  ¦       ¦   °--942255248      QUEST: RcrtES_Aware_v1r0_Mail                
    21  ¦       ¦--827220437          QUEST: RcrtES_Site_v1r0                      
    22  ¦       °--948195369          QUEST: RcrtES_PINmatch_v1r0                  
    23  ¦--104430631              RESP: No                                         
    24  ¦--125001209              RESP: Kaiser Permanente Colorado                 
    25  ¦--132232896              RESP: 100 or more                                
    26  ¦--151488193              RESP: 10 or less                                 
    27  ¦--181769837              RESP: Other                                      
    28  ¦--299561721              RESP: Yes, but rarely                            
    29  ¦--300267574              RESP: Kaiser Permanente Hawaii                   
    30  ¦--303349821              RESP: Marshfield Clinic Health System            
    31  ¦--317567178              RESP: In the past month                          
    32  ¦--327912200              RESP: Kaiser Permanente Georgia                  
    33  ¦--353358909              RESP: Yes                                        
    34  ¦--419415087              RESP: No, not at all                             
    35  ¦--452412599              RESP: Kaiser Permanente Northwest                
    36  ¦--484055234              RESP: More than a month ago, but in the past year
    37  ¦--486319890              RESP: 50 to 99                                   
    38  ¦--517700004              RESP: National Cancer Institute                  
    39  ¦--531629870              RESP: HealthPartners                             
    40  ¦--548392715              RESP: Henry Ford Health System                   
    41  ¦--648960871              RESP: Never                                      
    42  ¦--657167265              RESP: Sanford Health                             
    43  ¦--716761013              RESP: Yes, but some days                         
    44  ¦--802197176              RESP: More than 1 year ago                       
    45  ¦--804785430              RESP: Yes, every day                             
    46  ¦--805449318              RESP: 11 to 49                                   
    47  ¦--809703864              RESP: University of Chicago Medicine             
    48  °--812620303              RESP: N/A                                        

<div>

> **Notice that all of the RESPONSE concepts are nested directly under
> the root node rather than under the QUESTION objects. This is
> necessary because they can appear only once in the tree.**

</div>

### View dictionary as a dataframe

``` r
dd$df %>% 
  select(cid, path, key) %>%
  head(5)
```

            cid                               path
    1         0                                  0
    2 129084651                       0, 129084651
    3 965707586            0, 129084651, 965707586
    4 194557808 0, 129084651, 965707586, 194557808
    5 790436165 0, 129084651, 965707586, 790436165
                                                      key
    1                                          dictionary
    2                                              Survey
    3                  Smoking, Alcohol, and Sun Exposure
    4 How old were you when you first smoked a cigarette?
    5        Age first used cigarettes on a regular basis

### Retrieve a key, given a cid

``` r
cid <- 639684251
key <- cidtree::get_key(dd, cid)
print(key)
```

    [1] "Do you smoke cigarettes now?"

### Retrieve a concept id, given a key

``` r
key <- "Do you smoke cigarettes now?"
cid <- cidtree::get_cid(dd, key)
print(cid)
```

    [1] 639684251

### Retrieve all metadata using the cid

``` r
meta <- cidtree::get_meta(dd, cid)
meta$cid
```

    [1] 639684251

``` r
meta$path
```

    [1] "0, 129084651, 965707586, 639684251"

``` r
meta$var_name
```

    [1] "SrvSAS_UseCigsNow_v1r0"

``` r
meta$responses
```

    [1] "419415087, 299561721, 716761013, 804785430"

``` r
meta$concept_type
```

    [1] "QUESTION"

### Get variable name for a variable with a compound name

``` r
bq_var_name <- "d_142654897_d_461488577"
dd_var_name <- get_var_name(dd, bq_var_name)
dd_var_name
```

                    461488577 
    "RcrtES_Aware_v1r0_Email" 

## References

- This library is built on the
  [data.tree](https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html)
  library. So the `dd` object inherits has the same core functionality
  as an other `data.tree` object.
