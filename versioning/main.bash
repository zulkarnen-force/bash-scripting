VERSION=$(echo "1.1.1" | awk -F. '{ $NF = $NF + 1 } 1' OFS=.)
echo $VERSION # 1.1.2

plus_date=$(date +%m-%d-%Y -d "+10 days")
current_date=$(date +%m-%d-%Y -d "+10 days")
curl --location 'http://103.19.182.20/api-superapps/prayers/schedule' \
--header 'Accept: application/json' \
--form 'startDate="$current_date"' \
--form 'endDate="2023-12-05"'