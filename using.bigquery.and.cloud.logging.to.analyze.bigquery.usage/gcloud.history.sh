student_04_bf7e431c11b3@cloudshell:~ (qwiklabs-gcp-04-8604bb2ef60d)$ history
    1  gcloud auth list
    2  gcloud config list project
    3  bq query --location=us --use_legacy_sql=false --use_cache=false 'SELECT fullName, AVG(CL.numberOfYears) avgyears
    4   FROM `qwiklabs-resources.qlbqsamples.persons_living`, UNNEST(citiesLived) as CL
    5   GROUP BY fullname'
    6  bq query --location=us --use_legacy_sql=false --use_cache=false 'select month, avg(mean_temp) as avgtemp from `qwiklabs-resources.qlweather_geo.gsod`
    7   where station_number = 947680
    8   and year = 2010
    9   group by month
   10   order by month'
   11  bq query --location=us --use_legacy_sql=false --use_cache=false 'select CONCAT(departure_airport, "-", arrival_airport) as route, count(*) as numberflights
   12   from `bigquery-samples.airline_ontime_data.airline_id_codes` ac,
   13   `qwiklabs-resources.qlairline_ontime_data.flights` fl
   14   where ac.code = fl.airline_code
   15   and regexp_contains(ac.airline ,  r"Alaska")
   16   group by 1
   17   order by 2 desc
   18   LIMIT 10'
   19  history
student_04_bf7e431c11b3@cloudshell:~ (qwiklabs-gcp-04-8604bb2ef60d)$