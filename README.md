# cidtree
Jake Peters
2024-04-01

- [Introduction](#introduction)
- [Documentation](#documentation)
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
  - [Get variable name for a variable with a compound
    name](#get-variable-name-for-a-variable-with-a-compound-name)
  - [](#section)
- [References](#references)

<!-- README.md is generated from README.Rmd. Please edit that file -->

## Introduction

The objectives of `cidtree` package are to

1.  construct a `data.tree` object from a data dictionary

2.  provide convenient functions to explore the data dictionary

3.  automate the mapping of Concept IDs to the associated concepts and
    metadata.

4.  map concepts to their counterparts in the cidtree GCP tables

I intend this to be a toolkit to standardize the way that analysts
interact with the Connect for Cancer Prevention data dictionary.

## Documentation

Here is the [documentation
page](https://analyticsphere.github.io/cidtree/index.html).

A [pdf
reference](https://github.com/Analyticsphere/cidtree/blob/main/cidtree_docs.pdf)
document is also available.

## Examples

Load dependencies

``` r
library(dplyr)
library(data.tree)
library(jsonlite)
library(devtools)
library(gt)
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
```

    ── R CMD build ─────────────────────────────────────────────────────────────────
    * checking for file ‘/private/var/folders/ml/50_pnlgj113gylck6rb6cl4rkcm1_t/T/RtmpVCrbZJ/remotes107da8e08fa4/Analyticsphere-cidtree-9c089d5/DESCRIPTION’ ... OK
    * preparing ‘cidtree’:
    * checking DESCRIPTION meta-information ... OK
    * checking for LF line-endings in source and make files and shell scripts
    * checking for empty or unneeded directories
    * building ‘cidtree_0.1.0.tar.gz’
    Warning: invalid uid value replaced by that for user 'nobody'
    Warning: invalid gid value replaced by that for user 'nobody'

``` r
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

                         639684251 
    "Do you smoke cigarettes now?" 

### Retrieve a concept id, given a key

``` r
key <- "Do you smoke cigarettes now?"
cid <- cidtree::get_cid(dd, key)
print(cid)
```

    [1] "639684251"

### Retrieve all metadata using the cid

``` r
meta <- cidtree::get_meta(dd, cid)
meta$cid
```

    [1] "639684251"

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

### 

<div id="hniqwzbhne" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hniqwzbhne table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#hniqwzbhne thead, #hniqwzbhne tbody, #hniqwzbhne tfoot, #hniqwzbhne tr, #hniqwzbhne td, #hniqwzbhne th {
  border-style: none;
}
&#10;#hniqwzbhne p {
  margin: 0;
  padding: 0;
}
&#10;#hniqwzbhne .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#hniqwzbhne .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#hniqwzbhne .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#hniqwzbhne .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#hniqwzbhne .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#hniqwzbhne .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#hniqwzbhne .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#hniqwzbhne .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#hniqwzbhne .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#hniqwzbhne .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#hniqwzbhne .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#hniqwzbhne .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#hniqwzbhne .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#hniqwzbhne .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#hniqwzbhne .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hniqwzbhne .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#hniqwzbhne .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#hniqwzbhne .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#hniqwzbhne .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hniqwzbhne .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#hniqwzbhne .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hniqwzbhne .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#hniqwzbhne .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hniqwzbhne .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#hniqwzbhne .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#hniqwzbhne .gt_left {
  text-align: left;
}
&#10;#hniqwzbhne .gt_center {
  text-align: center;
}
&#10;#hniqwzbhne .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#hniqwzbhne .gt_font_normal {
  font-weight: normal;
}
&#10;#hniqwzbhne .gt_font_bold {
  font-weight: bold;
}
&#10;#hniqwzbhne .gt_font_italic {
  font-style: italic;
}
&#10;#hniqwzbhne .gt_super {
  font-size: 65%;
}
&#10;#hniqwzbhne .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#hniqwzbhne .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#hniqwzbhne .gt_indent_1 {
  text-indent: 5px;
}
&#10;#hniqwzbhne .gt_indent_2 {
  text-indent: 10px;
}
&#10;#hniqwzbhne .gt_indent_3 {
  text-indent: 15px;
}
&#10;#hniqwzbhne .gt_indent_4 {
  text-indent: 20px;
}
&#10;#hniqwzbhne .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="source">source</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="cid">cid</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="key">key</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="var_name">var_name</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="source" class="gt_row gt_right"></td>
<td headers="cid" class="gt_row gt_right">194557808</td>
<td headers="key" class="gt_row gt_left">How old were you when you first smoked a cigarette?</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_AgeCigsUseF_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right">790436165</td>
<td headers="cid" class="gt_row gt_right">408696162</td>
<td headers="key" class="gt_row gt_left">Age first used cigarettes on a regular basis number</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_AgeCigsUseRegF_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right">790436165</td>
<td headers="cid" class="gt_row gt_right">965482317</td>
<td headers="key" class="gt_row gt_left">Age first used cigarettes on a regular basis, Never smoked</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_NeverSmokedReg_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right">947205597</td>
<td headers="cid" class="gt_row gt_right">535003378</td>
<td headers="key" class="gt_row gt_left">None of the above</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_NoTobacco_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right">947205597</td>
<td headers="cid" class="gt_row gt_right">686310465</td>
<td headers="key" class="gt_row gt_left">Tobacco pipe</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_TobaccoPipe_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right">947205597</td>
<td headers="cid" class="gt_row gt_right">712653855</td>
<td headers="key" class="gt_row gt_left">Cigarettes (manufactured or hand-rolled)</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_Cigarettes_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right"></td>
<td headers="cid" class="gt_row gt_right">639684251</td>
<td headers="key" class="gt_row gt_left">Do you smoke cigarettes now?</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_UseCigsNow_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right"></td>
<td headers="cid" class="gt_row gt_right">763164658</td>
<td headers="key" class="gt_row gt_left">How many cigarettes have you smoked in your entire life?</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_CigarettesLife_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right"></td>
<td headers="cid" class="gt_row gt_right">798549704</td>
<td headers="key" class="gt_row gt_left">When was the last time you smoked cigarettes?</td>
<td headers="var_name" class="gt_row gt_left">SrvSAS_UseCigsLast_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right">142654897</td>
<td headers="cid" class="gt_row gt_right">461488577</td>
<td headers="key" class="gt_row gt_left">Email or text invitation</td>
<td headers="var_name" class="gt_row gt_left">RcrtES_Aware_v1r0_Email</td></tr>
    <tr><td headers="source" class="gt_row gt_right">142654897</td>
<td headers="cid" class="gt_row gt_right">607081902</td>
<td headers="key" class="gt_row gt_left">Invitation through my patient portal (such as MyChart)</td>
<td headers="var_name" class="gt_row gt_left">RcrtES_Aware_v1r0_Invite</td></tr>
    <tr><td headers="source" class="gt_row gt_right">142654897</td>
<td headers="cid" class="gt_row gt_right">942255248</td>
<td headers="key" class="gt_row gt_left">Letter or brochure in mail</td>
<td headers="var_name" class="gt_row gt_left">RcrtES_Aware_v1r0_Mail</td></tr>
    <tr><td headers="source" class="gt_row gt_right"></td>
<td headers="cid" class="gt_row gt_right">827220437</td>
<td headers="key" class="gt_row gt_left">Healthcare provider</td>
<td headers="var_name" class="gt_row gt_left">RcrtES_Site_v1r0</td></tr>
    <tr><td headers="source" class="gt_row gt_right"></td>
<td headers="cid" class="gt_row gt_right">948195369</td>
<td headers="key" class="gt_row gt_left">PIN match - autogenerated when entered PIN matches an active recruit PIN</td>
<td headers="var_name" class="gt_row gt_left">RcrtES_PINmatch_v1r0</td></tr>
  </tbody>
  &#10;  
</table>
</div>

## References

- This library is built on the
  [data.tree](https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html)
  library. So the `dd` object inherits has the same core functionality
  as an other `data.tree` object.
