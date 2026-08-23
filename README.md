# healthcare-admissions-sql-tableau
Healthcare admissions dashboard: SQL analysis + Tableau Public visualization of billing, admissions, and clinical outcomes.

Key Findings:
Admissions were broadly distributed across the six medical conditions, with Arthritis recording the highest number of admissions, while elective admissions were slightly more frequent than urgent and emergency admissions. Average billing was approximately ₹25.5K per admission, with variation across medical conditions, admission types, insurers, and hospitals, and test-result distributions were relatively balanced across Normal, Abnormal, and Inconclusive outcomes. Among hospitals with sufficient admission volume (30+ admissions), differences emerged in average billing, emergency-admission rates, and abnormal-test rates, although sample sizes even among these higher-volume hospitals remain modest.

Limitations:
The dataset is synthetic, so observed patterns may not represent real-world healthcare populations or costs. Length of stay was effectively constant at 30 days, limiting its usefulness for comparative analysis, and the dataset does not establish causal relationships between medications, conditions, billing, or test outcomes. Hospital-level comparisons are restricted to hospitals with 30+ admissions, and hospital/doctor names should not be interpreted as representing real entities or operational performance. The apparent decline in admissions in 2024 also reflects a partial-year dataset, so 2024 should not be compared directly with the preceding full years.
