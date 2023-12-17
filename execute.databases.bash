databases=(
    "sotabar"
    "sotabar"
)

filesql="sql/databases.sql"

for database in "${databases[@]}"
do
    # mysql -u root -pDataku_2023 -e "CREATE DATABASE IF NOT EXISTS $database;"
    mysql -u root -pDataku_2023 < $filesql;
done

# handle error