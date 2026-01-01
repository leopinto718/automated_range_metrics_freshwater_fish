# Automated calculation of EOO and AOO for regional conservation assessments of freshwater fish

This repository contains R scripts developed to **automate the calculation of Extent of Occurrence (EOO) and Area of Occupancy (AOO)** as part of a **regional conservation assessment of freshwater fish species**.

The scripts were used as one of the analytical steps supporting the regional extinction risk assessment that resulted in the following peer-reviewed publication:

> **Conservation status of the freshwater fish species from Ceará State, Brazil**  
> *Neotropical Ichthyology*  
> https://www.scielo.br/j/ni/a/hXVffBfk3KVL7GQ43R6SYKD/

---

## Purpose of this repository

This repository was created to:

- Ensure **transparency and reproducibility** of the spatial analyses used in the assessment;
- Provide a **documented and automated workflow** for calculating EOO and AOO;
- Support **regional-scale conservation assessments**, particularly for freshwater taxa whose distributions are structured by drainage systems.

The scripts are not intended to be a generic, one-size-fits-all implementation of IUCN metrics, but rather a **context-specific workflow** developed for a real conservation assessment.

---

## Methodological scope and disclaimer

- **Distribution Area** is defined as the union of **hydrographic sub-basins (HydroBASINS level 8)** intersecting species occurrence records.
- **EOO** is calculated as the **convex hull of the distribution area**, cropped to the political boundary of Ceará State (the analysis was conducted at a **regional scale**).


⚠️ **Important methodological note**

This workflow does **not** implement the standard IUCN grid-based AOO calculation (2 × 2 km cells).

Instead:

- **AOO**, in this implementation, is calculated as the area of occupied hydrographic units and is therefore **equivalent to the distribution area**.

- This approach was adopted following **([Freshwater species mapping standards for IUCN Red List assessments](https://nc.iucnredlist.org/redlist/content/attachment_files/Freshwater_Mapping_Protocol.pdf)** and is based on the premise that freshwater fish species distributions are strongly constrained by **drainage systems**;

Results produced by this workflow should **not be directly compared** to grid-based AOO estimates calculated under the global IUCN Red List standard.

---

## Repository structure

```text
iucn-eoo-aoo/
│
├── README.md
├── LICENSE
│
├── data/
│   ├── raw/            # Occurrence records (CSV)
│   └── spatial/        # Shapefiles (Ceará boundary, HydroBASINS, CRS reference)
│
├── scripts/
│   ├── 01_data_preparation.R      # Data cleaning and filtering
│   ├── 02_range_metrics.R         # Distribution area, EOO and AOO calculation
│   └── 03_mapping_and_exports.R   # Map generation
│
└── outputs/
    ├── species/        # Species-level shapefiles and maps
    └── summary/        # Summary tables
