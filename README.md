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

There is probably a natural history of human societies. Multiscalar, parsimonial, bottom-up, agglomerative, unsupervised and data-driven statistical approaches should be favored since we did not know, *a priori*, what aspects and at which scale (from settlement to continent) will be the positive results. By nature, the data on past societies are multi-dimensional, come from different scales (quantitative, ordinal, categorical, etc.) and change of scales. Multifactorial analysis will permit to enlighten pattern in the datasets. The clustering process, adjusted to the granularity of the analysis, will reduce the variability of distributions by distinguishing different clusters. The archaeological investigation can be divided into:

* 'What' (culture) participate to the processes
* 'Where' (geography) did these processes occurred
* 'When' (time) did these processes occurred
* 'Who' ([genetic](https://github.com/zoometh/aDNA#adna)) participate to these processes
* 'Why' past societies choose a solution instead of another
* 'How' does it works
* 
Two global dimensions of social groups can be distinguished: its genetic identity and its cultural identity. Cultural and genetic identities will be defined relatively to the central tendencies (i.e. mean, median, standard deviations) of their cultural and genetic traits.

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

## Methods

Programming language (like R or Python) permit to connect existing online databases, iterate statistics routines, generate reports with online interactive forms, etc. 

## Axes

### Gene-culture coevolution

### Prehistoric iconography {#symbolic} <img src="/img/moulin_t142.png" align="right" width="120"/>

Iconography represent a part of the symbolic subsystem. The [*iconr* R package](https://zoometh.github.io/iconr/) helps to model iconographic content with Graph theory and GIS

### Spatio-temporal modeling

#### Space modeling

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
analyses;

#### Time modeling

Development of databases, webpages, interactive apps functions with R for radiocarbon/dendrochronological data management (collect, calibration, analysis, modeling)... visit the [GitHub repo](https://github.com/zoometh/C14#radiocarbon-data-integration-and-visualization)

### ABM

Once *facts* established and patterns recognized, spatio-temporal
*scenarios* will also be proposed. ABM permits to simulated interactions
between local entities (agents or patches) within an environment (the
so-called 'world'). For historical sciences, it permits to infer past
mechanisms (simulated data) from the observation of the present
situation (observed data). In archaeology, ABM had been appropriately
employ, for example, to explain the LBK Neolithic diffusion[@Dubouloz].
LBK diffusion is almost continuous and seems to correspond to the
so-called 'ideal despotic distribution' model (IDD model): after a
village scission and a migration, LBK families, or groups, founded a new
settlement in the best soils ('best patches')[@Shennan07]. The village
scission is probably triggered by a high consumption/production (C/P)
ratio: a population growth and a correlative decreasing productivity for
food production [@Dubouloz]. This processes are also visible in the LBK
village organization. This latter shows two kinds of houses: small
houses with ceramic innovations, craft activities, importance of hunting
products, few grinding tools, without granaries, etc., and big houses
with traditional ceramics, ox dominant, concentration of grinding tools,
granaries, etc. The small houses are considered to be those of the new
incomers into the village, while big houses correspond to more ancient
inhabitants and lineages [@Coudart98][@Gomart15]. These observations
will be further developed as part of the ANR Homes[^3]. To be
meaningfully conducted on Neolithic contexts, ABM necessarily needs to
be simple and grounded on robust observations: its task is to enlighten
emerging complex structures from simple interactions and models by
identifying threshold effects (e.g. agriculture capabilities, estimated
population size). Our ABM will be based on aDNA data and cultural traits
analyses. Agents (*turtles* in NetLogo) and patches (field units in the
'world') will be social groups, villages, agrarian units, family
lineage, etc. We will employ, and develop, existing mathematical models
of interactions: between different agents (e.g. gravity models), or
between agent and its environment (e.g. GLUES model [@Lemmen11]).
Considering populations' size and demography, summed radiocarbon
probability distributions (SRPD), settlement studies, and analyses of
funeral domain (e.g. necropolis, average age of death) would be used as
a proxy. Map algebra, taking into account nature of the soil, average of
precipitation, temperature and cloudiness, will permit to infer the
agriculture capabilities of patches. By programming simulations with
different inputs and models, we will test scenarios of historical
developments to find the most likely to explain observed regularities.
For each type of simulation the definition of the region of interest,
different levels of interactions, rules of adaptation and emergence,
models, types of statistical outputs, etc. will be done respecting the
Overview, Design concepts, and Details (ODD) protocol. A particular
interest will be put on the study of the time dimension.

### Case studies

#### Spread of farming during Mesolithic/Neolithic transition

The time period covered by the Mesolithic-Neolithic transition to the Late Neolithic represents three major demic diffusions: 

1. the arrival of Anatolian early farmers during the Early Neolithic [@Bentley]
2. the arrival of North-Pontic populations into the Corded-Ware complex (CWC) area during the Late Neolithic [@Brandt13]
3. the spread of the Bell-Beaker complex (BBC) at the very end of Late Neolithic [@Olalde]

Between these major population diffusions, smaller demic changes occurred. Final Mesolithic societies (ca. 7000-6000 BC) are considered
to form the background of the early farmers arrivals. They are collectors-gatherers with a low net reproduction rate [@Diamond],
generally a semi-sedentary residence (i.e. foragers), living in small groups with few storage capacities [@Binford] and long-distance
exchanges are sparse [@Karamitrou]. Direct contacts between these last Mesolithics and first farmers, or close settlements, are very few. In Eastern and Northern Europe, despite various material exchanges, few admixtures between early farmers farmers and indigenous hunter-gatherers have been observed: the [hg U5](https://sites.google.com/view/haplotree-info/home/mtdna-u5) is typical of last hunter-gatherers/Mesolithics and the [hg N1a](https://sites.google.com/view/haplotree-info/home/y-dna-n) is typical of early farmers. Mesolithics could have backed up to West Europe, the westernmost part of the Eurasian continent, and admixture could be more frequent in the West. In the middle Rhine valley, last hunter-gatherers populations have probably played a role in the Michelsberg cultural
affirmation [@Beau] and such interrogations also exist for the development of Megalithism along the Atlantic shore [@Ard18].

Indeed, during this period and from Greece to Spain, we observed an absence of occupations (the so-called \"hiatus\" or \"gap\"). This
\"hiatus\" is maybe due to a major mobility at the end of the 7^th^ millenium BC linked to a major climatic event (8.2 Ky BP event) with
drying and cooling in Europe [@Guilaine]. The earliest Neolithic culture in Europe concerns the South-eastern part of the continent occupied by
the PPC, ca 6500-6000 BC. After PPC diffusion in Greece, Thrace and the Balkan peninsula, a first stop in the progression is observed on its
western and northern frontiers, respectively in western Greece with the PPC/ICC transition, and in the western Hungarian with the PPC/LBK
transition.

1. The former frontier, near the archaeological site of Sidari (Corfu, Greece), seems to depend on a renewal of the Neolithic culture
[@Guilaine1]
2. The second frontier (PPC/LBK transition) is linked to the Central European-Balkanic agro-ecological barrier and may result in the
adaption of the agro-pastoral way of living to a new environment. For example, the development of farming and breeding in northern parts of
Europe needs the development of a day length non-response gene (PPD-H1) for the barley [@Jones]. 

After that, the two main currents for the beginning of farming in Central and Western Europe are the ICC (ca 5800-4900 BC) in the Mediterranean area, and the LBK (ca 5600-4900 BC) in the continent area. These currents where relatively fast even if other delays can also be observed in the diffusion of farming [@Guilaine1].

ICC current of farming is the fastest but shows spatial discontinuities
(leapfrog movements) [@Binder1]. The first phase of ICC, Impressa
pioneer front, is short (ca 5800-5600 BC). The material culture of
Impressa (e.g. lithics, subsistence system) shows significant
differences with the Mesolithic indigenous. But contacts between
Mesolithics and Early Neolithics exist: Impressa layers of Arene Candide
(Finale Ligure, Liguria) show flints coming from a region controlled by
late Mesolithic groups (Monti Lessini in Appenins)[@Binder2]. The second
phase of ICC, Cardial (ca 5600-5000 BC), shows more connections and
admixture with the Mesolithic way of living with, for example, a part of
the hunting in the subsistence system and adoption of lithic tools. This
latter phase could be interpreted as an acculturation phase between
Neolithics and Mesolithics.

LBK current of neolithisation shows a homogeneous culture (settlement,
ceramic and lithic productions, subsistence system) recognized for a
long time by archaeologists thanks to a favorable taphonomy of the
settlements. As said, its diffusion seems to correspond to the IDD model
where the demic factor is the most important one. Few genetic admixture
has been recognized between Recent LBK farmers and latest
hunter-gatherers even in Western Europe [@Rivollat2016].

In Western Europe, first evidence of contacts between Recent LBK and
Late Cardial (ca. 5200-4700 BC) takes place on both sides of an almost
East-West middle-ground, extended from the middle part of the Rhone
valley to the north of the Aquitaine basin. The Middle Neolithic
(4500-3500 BC), except for the margins of Europe, is the achievement
period of the farming diffusion process. This is a period of relative
homogeneity and long-distance trades (green-stones, obsidian, bedoulian
flint, etc.). It is not clear if this networks of distance trades were
also the place of significant demic diffusion or if they were only
traits exchanges. Megalithism starts as a response to a demographic
stress [@Hamon18]. The mining phenomena also starts (e.g. in Chassean
and Michelsberg contexts). Mining activities were probably the most
complex activities of the period, they requires a complex organization
all along the CO. At the westernmost part of the continent, the English
Channel between the agro-pastoral continent and the British Islands, is
crosses around 4000 BC by early farmers [@Collard].

#### Networks during the Protohistory <img src="/img/Ha_Gol.png" align="right" width="120"/>

A [R + Leaflet + Plotly webpage](https://zoometh.github.io/golasecca/) dedicated to the networks of artefacts *versus* networks of potential paths during the First Iron Age in the Central Alps. We Our purpose is also the *Reuse* of data in a context of Open Science  

### Roman stelae from the South of France

The [Epispat_R shiny app](https://epispat.shinyapps.io/analyses_mult_5/) for multifactorial analysis on the [Base_Epigraphique database](https://www.cepam.cnrs.fr/ressources/bases-de-donnees/archaepigraph/) 
