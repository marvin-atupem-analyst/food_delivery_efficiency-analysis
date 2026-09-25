# Food Delivery Data Analysis
## Project Objective
This dataset is for a food delivery business that aims to investigate the factors that affect its delivery efficiency.
I aim to explore the data, find meaningful patterns, communicate the findings and provide useful recommendations based on the data.

## Dataset
-	The name of the dataset is Food Delivery Route Efficiency Dataset
-	View Dataset Here!
-	The dataset contains 10 columns and 200 rows excluding the headings.
-	Dataset Variables
  
| Variable | Description | 
| :---| :---| 
| `order_id` | Unique identifier for each order | 
| `distance_km` | Distance covered for the delivery | 
| `delivery_time_min` | Time taken to complete the delivery | 
| `traffic_level` | Traffic condition during delivery | 
| `route_length_km` | Length of the selected delivery route | 
| `delivery_mode` | Mode used to deliver the order | 
| `weather` | Weather condition during delivery | 
| `order_time` | Time the order was placed | 
| `restaurant_zone` | Zone where the restaurant is located | 
| `customer_zone` | Zone where the customer is located |

## Business Problem
A food delivery company is experiencing differences in the amount of time it takes to deliver customer orders. Management wants to understand: **What factors are affecting delivery time, and how can the company improve its delivery efficiency?**

## Questions
* **What is the total number of orders the business has had?**
* **What is the average delivery time?**
* **Which delivery mode is used most frequently?** 
* **Which weather condition has the highest average delivery time?** 
* **Which restaurant or customer zone has the most deliveries?** 
* **Does delivery distance affect delivery time?** 
* **Does route length affect delivery time?** 
* **How does traffic level relate to delivery time?** 
* **Which delivery mode has shorter delivery times?** 
* **Does order time appear to influence delivery time?** 
* **Are there noticeable differences between zones?**

## Data Cleaning
### Using MySQL 
The order_time column was not in the right structure, so I made that order time a varchar column and then created two new columns called order_time and order_date. Then I updated the new two columns with the right date and time from the original order_time.

## Data Exploration
### Using MySQL
1.	**What is the total number of orders the business has had?**
* **Result:** The total number of food delivery orders is 200.
* **Insight:** This gives us the total sample size of the orders.

2. **What is the average delivery time?** 
* **Result:** The average delivery time across all 200 orders is 44.74 minutes.
* **Insight:** This is the baseline average when no other factors is taken into consideration.

3. **Which delivery mode is used most frequently?** 
* **Result:** Out of the 200 orders, Bicycle and Scooter were the most frequently used delivery modes, with each accounting for 52 orders.
* **Insight:** This shows that Bicycle and Scooter were the most frequently used delivery modes in the dataset.

4. **Which weather condition has the highest average delivery time?** 
* **Result:** Cloudy weather had the highest average delivery time at 49.94 minutes.
* **Insight:** This shows that orders made during cloudy weather had the highest average delivery time in the dataset.

5. **Which restaurant or customer zone has the most deliveries?**
* **Result:** South had the highest number of restaurant-zone deliveries with 54 orders, while North had the highest number of customer-zone deliveries with 46 orders.
* **Insight:** This shows that South was the busiest restaurant zone, while North received the highest number of deliveries among the customer zones.

6. **Does delivery distance affect delivery time?** 
* **Result:** Short distances like **'0 to 2km'** average **11.68** minuites while long distances like **'11+km'** averages **76.17** minutes.
* **Insight:** I noticed that as the delivery distance increases, the total time taken to deliver the food also increases consistently.

7. **Does route length affect delivery time?** 
* **Result:**
			- 10km+ (Far): 69.91 minutes average delivery time
			- 6 to 10km (Medium): 45.00 minutes average delivery time
			- 3 to 6km (Close): 23.64 minutes average delivery time
			- 0 to 3km (Very Close): 9.71 minutes average delivery time
* **Insight:** I notied that as the length of the delivery route gets longer, the average time taken to deliver the food increases significantly, jumping from just under 10 minutes for very close routes to nearly 70 minutes for far routes.

8. **How does traffic level relate to delivery time?** 
* **Result:** Low traffic level has the highest average delivery time of 47.05 minutes.
* **Insight:** Low traffic had the highest average delivery time, which was different from what I initially expected. This suggests that traffic level alone may not explain the differences in delivery time. Other factors such as delivery distance, route length or delivery mode may also be involved.

9. **Which delivery mode has shorter delivery times?** 
* **Result:** Car has the shortest average delivery time at 41.48 minutes.
* **Insight:** Cars had the shortest average delivery time among the delivery modes in the dataset.

10. **Does order time appear to influence delivery time?** 
* **Result:**
			- Evening: 47.33 minutes average delivery time
			- Morning: 47.07 minutes average delivery time
			- Midnight/Dawn: 45.01 minutes average delivery time
			- Afternoon: 40.82 minutes average delivery time
* **Insight:** I notied that delivery times stay almost exactly the same (around 45 to 47 minutes) for most of the day and night, except for a sudden drop during the afternoon hours were deliveries become significantly quicker.

11. **Are there noticeable differences between zones?**
* **Result:** Out of 25 distinct route combinations, the slowest route are North to South (66.87 minutes) and East to South (60.62 minutes), while other routes complete much faster.
* **Insight:** I noticed that some zone-to-zone routes had much higher average delivery times than others, especially North to South and East to South. These routes should be investigated further to understand what factors may be contributing to the longer delivery times.

## Dax Calculations
1. New Column for grouped distances
```dax
Distances_Group = 
SWITCH(
    TRUE(),
    food_delivery_rroute[distance_km] <3,"0 to 2km",
    food_delivery_rroute[distance_km] <6,"3 to 5km",
    food_delivery_rroute[distance_km] <11, "6 to 10km", "11+")
```
	
2. New Column for concated delivery routes
```dax
Delivery_Route = 'food_delivery_rroute'[restaurant_zone] & " to " & food_delivery_rroute[customer_zone]
```

4. Calculated new columns fo time of the day
```dax
Time_of_the_day = 
VAR OrderHour = HOUR(food_delivery_rroute[order_time])
RETURN
SWITCH(
    TRUE(),
    OrderHour >= 0 && OrderHour <6,"Midnight/Dawn",
    OrderHour >= 6 && OrderHour <12,"Morning",
    OrderHour >= 12 && OrderHour <18,"Afternoon", "Evening"
)
```

4. Total orders
```dax
Total Orders = COUNT(food_delivery_rroute[order_id])
```

6. Average Route Length
```dax
Average Route Length = AVERAGE(food_delivery_rroute[route_length_km])
```

8. Average Delivery Time
```dax
Average delivery time = AVERAGE(food_delivery_rroute[delivery_time_min])
```

10. Average Distance
```dax
Average Distance = AVERAGE(food_delivery_rroute[distance_km])
```

## Power BI Dashboard
I built an interactive dashboard to visually look at the factors that are affecting delivery time. Below is what each visualization stands for in the dashboard:

1. **KPI Cards**
* **Visual Type:** Card (New)
* **Purpose:** This displays the main company metrics which includes the Total Orders (200), Average Route Length (8.16 km), Average Delivery Time (44.74 minutes), and Minutes per Kilometer (6.62 mins/km) to show the general baseline performance.

2. **Delivery Time by Route**
* **Visual Type:** Line Chart
* **Purpose:** This shows specific zone-to-zone route combinations and their average delivery times. It helps to easily see how the line shows differences in average delivery time between zone-to-zone routes, with some routes such as North to South having considerably higher average delivery times.

3. **Time vs. Vehicle Type**
* **Visual Type:** Clustered Bar Chart
* **Purpose:** This compares the time taken by different transport choices like Car, Bike, Scooter, and Bicycle. It helps to show that the bars are almost equal, meaning trip times are steady regardless of the vehicle type used.

4. **Peak Hours Analysis**
* **Visual Type:** Clustered Bar Chart
* **Purpose:** This breaks down the delivery times by different shifts which are Evening, Morning, Midnight/Dawn, and Afternoon. It helps to pinpoint the exact hours where delivery speed changes during the day.

5. **Interactive Filters**
* **Visual Type:** Tile Slicers and Dropdown
* **Purpose:** These slicers allow users to filter the dashboard by Traffic Level, Weather Condition and Delivery Route, making it easier to examine how delivery performance changes across different conditions.

## Key Findings
1. **Delivery distance has a strong relationship with delivery time.**
Short-distance deliveries between 0–2 km took an average of 11.68 minutes, while deliveries above 11 km took an average of 76.17 minutes. This shows that delivery time increases as the delivery distance increases.

2. **Longer routes require considerably more delivery time.**
Very close routes of 0–3 km had an average delivery time of 9.71 minutes, while routes above 10 km had an average delivery time of 69.91 minutes. This shows that route length is an important factor when looking at delivery efficiency.

3. **Some zone-to-zone routes have much higher delivery times than others.**
The North to South route had the highest average delivery time at 66.87 minutes, followed by East to South at 60.62 minutes. This shows that delivery performance differs across specific routes.

## Recommendations
1. **Improve route planning for longer-distance deliveries.**
The business should review longer delivery routes and look for opportunities to reduce unnecessary travel distance and improve route efficiency.

2. **Investigate high-time routes.**
Routes such as North to South and East to South should be investigated further to understand whether distance, traffic, delivery mode, route selection or other factors are contributing to their longer delivery times.

3. **Use distance and route information when planning deliveries.**
The business should consider delivery distance and route length when assigning deliveries and setting realistic delivery-time expectations. Longer deliveries naturally require more time, so this information can help with better operational planning.

## Conclusion
Delivery efficiency varies across orders. The analysis shows that distance and route length have the clearest relationship with delivery time. Some zone-to-zone routes also have substantially higher average delivery times. Other factors, such as delivery mode, weather, traffic and time of day, show differences in the dataset, but the available data does not establish that these factors independently cause longer delivery times.

