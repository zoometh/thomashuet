## Thomas Huet (Dr.)
> Archaeology and IT methods

[LabEx ARCHIMEDE](https://archimede.cnrs.fr/), Associate Researcher UMR 5140 ASM-CNRS, Université Paul-Valéry Montpellier 3, France

* mail: [thomashuet7@gmail.com](thomashuet7@gmail.com)
* CV: [https://github.com/zoometh/thomashuet.github.io/raw/main/cv/cv_english.pdf](https://github.com/zoometh/thomashuet.github.io/raw/main/cv/cv_english.pdf)
* ORCID: [0000-0002-1112-6122](https://orcid.org/0000-0002-1112-6122)
* Google Scholar: [2hKEVaIAAAAJ&hl](https://scholar.google.fr/citations?user=2hKEVaIAAAAJ&hl=en&oi=sra)
* ResearchGate: [Thomas_Huet2](https://www.researchgate.net/profile/Thomas_Huet2)
* webpages:
  + professional: [https://archimede.cnrs.fr/index.php/annuaire/123-annuaire/e-h/456-thomas-huet](https://archimede.cnrs.fr/index.php/annuaire/123-annuaire/e-h/456-thomas-huet)
  + GitHub: [https://github.com/zoometh](https://github.com/zoometh)

## Statement

There is probably a natural history of human societies. Adolphe Quetelet's statistical observations of the oscillations around the mean value -- and his concept of "average man" (*homme moyen*) -- show that parsimonial, multiscalar, bottom-up and agglomerative are suitable methods to describe data and datasets. Multifactorial, unsupervised and data-driven analysis are favored since we did not know, *a priori*, what aspects and at which scale (from the settlement to the continent) will give the positive results. The archaeological investigation can be divided into 5 dimensions:

* 'What' ([culture](https://github.com/zoometh/thomashuet/blob/main/README.md#what)) participate to the processes
* 'Where' ([geography](https://github.com/zoometh/thomashuet/blob/main/README.md#where)) did these processes occurred
* 'When' ([time](https://github.com/zoometh/thomashuet/blob/main/README.md#when)) did these processes occurred
* 'Who' ([genetic](https://github.com/zoometh/thomashuet/blob/main/README.md#who)) participate to these processes
* 'Why' past societies choose a solution instead of another
* 'How' does it works

Two global dimensions of social groups can be distinguished: its genetic identity and its cultural identity. Cultural and genetic identities will be defined relatively to the central tendencies (i.e. mean, median, standard deviations) of their cultural and genetic traits.

### What

**Cultural identity** is the product of a set of cultural traits. Cultural traits are considered in terms of presence/absence, relative quantities and correlations of various items belonging to material (raw material, settlements, etc.) and practices (technical, symbolic, etc.). A cultural trait can be shared (at different degrees), or not, by different groups. Renfrew and Bahn (1991) have modeled the different cultural subsystems:

| subsystem   | description  | 
|-------------|-------------|
|subsistence  |  interactions around food resources |
|technological |  set of *chaines opératoires* for artifacts production |
|social |  set of inter-individuals and intra-group interactions |
|symbolic |  languages, [picture production](https://github.com/zoometh/thomashuet/blob/main/README.md#iconography-), religions, etc. |
|external trade   |  trade exchanges inter-groups |
|demographic   | population size (scale factor) |
|ecological   |  set of natural features |

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
[@Renfrew]

### Iconography <img src="/img/moulin_t142.png" align="right" width="120"/>

Iconography represent a part of the symbolic subsystem. The [*iconr* R package](https://zoometh.github.io/iconr/) helps to model iconographic content with Graph theory and GIS


### Where

Spatialization will permit to respond to the question: 'Where ?'.
Spatial distributions of social groups are the result of historical
processes. For example, last Mesolithic sites are preferentially located
in the mountain -- maybe because of the Neolithic pressure created by
the arrival of first farmers -- while early farming sites occupied
fertile lands: soils of the Balkans flood plains during Painted Pottery
complex (PPC) diffusion, loessic soils of Central Europe and morainic
soils of the Northern Alps during LBK diffusion (id. in the Southern
Alps during Cardial diffusion). Spatial statistics have various indexes
or models able to describe and explain spatial distributions. For
example, we will calculate cost-weighted time of walk buffers from site
locations (site catchment analysis) to study both site environmental
context (site supply, repository of raw materials, land cover and arable
lands, local climate, etc.) and inter-site connections. For traditional
societies, a terrestrial 50/60 km radius, corresponding roughly to a
day's walk, would be a theoretically good threshold below which
principal genetic and cultural traits (marriage, language, economic
exchanges, etc.) are optimal. Map algebra between land cover, slopes,
climatic model, etc., will be used to evaluate the attractiveness of
soils. Spatial statistics (e.g. semi-variograms), indexes (e.g.,
autocorrelation Moran's I, location quotient) or pattern distribution
(e.g. Ripley's K function, Kernel density) will permit to characterize
social groups' spatial distributions [@Nakoinz]. Geographic models (e.g.
core-periphery, down-the-line, directional trade) will permit to match
past observations with present ones (ethnographic, economic). To reduce
the variability of the dataset, sites will be clustered according to
their own specificities (e.g. category, size) and their inter-relations
(e.g. geographical or network distances, genetic and cultural
differences of their inhabitants). Beside geographical analysis, network
analysis will be performed when qualitative \"connections\" between
\"nodes\" (these terms are contextually-defined) will be observed.
Different R packages permit to manage both geographical and network
analyses.

### When

Development of databases, webpages, interactive apps functions with R for radiocarbon/dendrochronological data management (collect, calibration, analysis, modeling)... visit the [GitHub repo](https://github.com/zoometh/C14#radiocarbon-data-integration-and-visualization)

### Who
> [project](https://github.com/zoometh/aDNA#adna) 

**Genetic identity** of a population is its genetic signature. Genetic analysis permit to evaluate genetic populations similarities by comparison of ancient DNA (aDNA) sequences. On the base of single-nucleotide polymorphisms (SNPs) study, the neutral hypothesis (H~0~, i.e. a population continuity with few random genetic drifts) can be rejected (H~1~ accepted) and factors like mutation, selection and migration can be supposed. At the time scale we investigate (Recent Prehistory), only the migration factor could explain observed significant changes in the genetic of populations. Differences between populations can be detected by different means but the determination of groups (e.g. indigenous, immigrants) is mostly based on the study of the SNPs or discrete haplogroup (hg) frequencies [@Bramanti09].
Each individual belongs to a hg. Individual sharing a common hg have also a common ancestor. Genetic traits are considered in terms of presence/absence, relative quantities and correlations of hg. A hg can be shared (in different proportions), or not, by different groups.  The R packages [ape](https://cran.r-project.org/web/packages/ape/index.html) and [pegas](https://cran.r-project.org/web/packages/pegas/index.html), among others, permit to perform analysis of Molecular Variance (AMOVA), genetic mapping (e.g. phylogenetic trees, haplotype network, median-joining network) and cluster analysis (multidimensional scaling, dendrogram, etc.)
