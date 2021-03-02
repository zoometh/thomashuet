# Thomas Huet (Dr.)
> IT development, methods and models for Archaeology

[LabEx ARCHIMEDE](https://archimede.cnrs.fr/), Associate Researcher UMR 5140 ASM-CNRS, Université Paul-Valéry Montpellier 3, France

* mail: [thomashuet7@gmail.com](thomashuet7@gmail.com)
* CV: [https://github.com/zoometh/thomashuet.github.io/raw/main/cv/cv_english.pdf](https://github.com/zoometh/thomashuet.github.io/raw/main/cv/cv_english.pdf)
* ORCID: [0000-0002-1112-6122](https://orcid.org/0000-0002-1112-6122)
* Google Scholar: [2hKEVaIAAAAJ&hl](https://scholar.google.fr/citations?user=2hKEVaIAAAAJ&hl=en&oi=sra)
* ResearchGate: [Thomas_Huet2](https://www.researchgate.net/profile/Thomas_Huet2)
* webpages:
  + professional: [https://archimede.cnrs.fr/index.php/annuaire/123-annuaire/e-h/456-thomas-huet](https://archimede.cnrs.fr/index.php/annuaire/123-annuaire/e-h/456-thomas-huet)
  + GitHub: [https://github.com/zoometh](https://github.com/zoometh)

## Statements

There is probably a natural history of human societies. Therefore, statistical approaches could be relevant. The archaeological investigation can be divided into:

* 'What' (culture) participate to the processes
* 'Where' (geography) did these processes occurred
* 'When' (time) did these processes occurred
* 'Who' (genetic) participate to these processes
* 'Why' past societies choose a solution instead of another
* 'How' does it works
* 
Two global dimensions of social groups can be distinguished: its genetic identity and its cultural identity.

1.  **Genetic identity** of a population is its genetic signature. Each individual belongs to a hg. Individual sharing a common hg have also a common ancestor. Genetic traits are considered in terms of presence/absence, relative quantities and correlations of hg. A hg can be shared (in different proportions), or not, by different groups (see [here](https://github.com/zoometh/aDNA)).

2.  **Cultural identity** is the product of a set of cultural traits. Cultural traits are considered in terms of presence/absence, relative quantities and correlations of various items belonging to material (raw material, settlements, etc.) and practices (technical, symbolic, etc.). A cultural trait can be shared (at different degrees), or not, by different groups. Renfrew and Bahn (1991) have modeled the different cultural subsystems:

| subsystem   | description  | 
|-------------|-------------|
|subsistence  |  interactions around food resources |
|technological |  set of *chaines opératoires* for artifacts production |
|social |  set of inter-individuals and intra-group interactions |
|[symbolic](#symbolic)   |  languages, picture production, religions, etc. |
|external trade   |  trade exchanges inter-groups |
|demographic   | population size (scale factor) |
|ecological   |  set of natural features |

[@Renfrew]

Study of archaeological cultures will permit to respond to the question:
'What ?'. It will contribute to define the cultural identity of the
social groups. For example, Impressa-Cardial complex (ICC) is named
after its ceramic characteristics (impressed and *cardium* decorations)
and is associated to different cultural traits: settlement
particularities (e.g. proximity to sea shore), production economy (e.g.
wheat, domestic goats), specific diet (cereal-based consumption), etc.
There is no consensus on which cultural traits (e.g. ceramic
productions, settlements system, diet) have to be selected in order to
compare and measure cultural (dis)similarities. Each selection of these
traits will have to be explicitly justified. Commonly, cultural traits
will be selected into the different subsystems of a social group
organization [@Renfrew]: subsistence (e.g. relative % of domestic and
wild animals consumption), technological (e.g. presence/absence of loom
weights), social (e.g. social hierarchy[^2]), symbolic (e.g.
iconography), external trade (e.g. presence/absence of long-distance
exchanges) and demographics (e.g. average ages of death). A key notion,
for the cultural dimension, is the notion of *chaîne opératoire* (CO).
The CO is a sequence of technical gestures, following the same order,
that transform the raw material into a usable product [@Cresswell1].
Beside the technical constraints (i.e. the technical efficiency), the
more complex is the CO, the less likely two different cultures could
share the same CO without having any previous cultural interactions
(i.e. trait-adoptions). In this way, complex COs are close to the notion
of *style*: a \"highly specific and characteristic manner of doing
something (\...) always peculiar to a specific time and place\"
[@Sackett77]. Studies of complex COs cover numerous fields of social
activities (e.g. acquisition, production, shaping, trade and use of
lithic materials) and are key values concerning the recognition of
trait-adoptions. Just like significant changes in the demographic
subsystem imply significant changes in the social organization
[@BocquetAppel2008], restructuration of ceramic decorations reflect a
cultural shift [@Demoule] and changes in complex COs reflect also social
changes. Within others cultural traits, a social group is defined by its
diet and its type of mobility. Isotopes analysis permit to work on
mobility (isotopes of Pb, Sr and O), diet (N and C) and seasonality (Sr
and O). As an example, isotopic analyses on mobility of
Linearbandkeramik complex (LBK), partly confirmed by the DNA analyses,
show that women have generally a higher rank of mobility (nonlocal
women) than men [@Shennan]. The main reason seems to be linked to the
matrimonial regime (patrilocal) [@Brown][@Kristiansen]. Diet isotopes,
permit to enlighten cultural traits for a given group. For example,
during the first part of ICC Neolithic diffusion (*Impressed ware*
period) the Neolithic incomers have a terrestrial diet (relative high
levels of ^15^N and low levels of ^13^C isotopes are linked with meat
consumption), without any maritime product, although the sites are
significantly close to the seashore [@Lightfoot]. Seasonality isotopes
are specially interesting to study mobility of foragers groups
(multiseasonal circulating mobilities with a relocation of the
residential base), transhumance practices, etc. Isotopes are
space-dependent, they can be studied geographically, taking into account
the geology, land cover, etc., and spatial analysis, site catchments,
shorter paths, etc. Once selected identical cultural traits in different
groups, (dis)similarities between these groups will be measured in R
with appropriated packages, functions or indexes: Bray-Curtis
coefficient for contingency tables, Jaccard index for presence/absence
tables, etc.

### Prehistoric iconography {#symbolic} <img src="/img/moulin_t142.png" align="right" width="120"/>

Iconography represent a part of the symbolic subsystem. The [*iconr* R package](https://zoometh.github.io/iconr/) helps to model iconographic content with Graph theory and GIS

### Time modeling

Development of databases, webpages, interactive apps functions with R for radiocarbon/dendrochronological data management (collect, calibration, analysis, modeling)... visit the [GitHub repo](https://github.com/zoometh/C14#radiocarbon-data-integration-and-visualization)

### Networks during the Protohistory <img src="/img/Ha_Gol.png" align="right" width="120"/>

A [R + Leaflet + Plotly webpage](https://zoometh.github.io/golasecca/) dedicated to the networks of artefacts *versus* networks of potential paths during the First Iron Age in the Central Alps. We Our purpose is also the *Reuse* of data in a context of Open Science  

### Roman stelae from the South of France

The [Epispat_R shiny app](https://epispat.shinyapps.io/analyses_mult_5/) for multifactorial analysis on the [Base_Epigraphique database](https://www.cepam.cnrs.fr/ressources/bases-de-donnees/archaepigraph/) 
