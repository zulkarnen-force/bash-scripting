#!/bin/bash
function update_variabel() {
    curl --location --request PUT "https://git.muhammadiyah.or.id/api/v4/projects/13/variables/$1" \
        --header 'PRIVATE-TOKEN: glpat-QsU1xcohc7qaW4x3zeyL' \
        --form "value="$2""
}
current_minor_version=1
current_patch_version=10
current_patch_version=$((current_patch_version + 1))
echo $current_patch_version
if [ "$current_patch_version" -ge 10 ]; then
    echo "The variable is greater than 10."
    current_minor_version=$((current_minor_version + 1))
    update_variabel "DEV_MINOR" $current_minor_version
    current_patch_version=0
    echo $current_patch_version
    update_variabel "DEV_PATCH" $current_patch_version
else 
    echo "else.."
    update_variabel "DEV_PATCH" $current_patch_version
fi