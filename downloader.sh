#!/bin/bash

# Define an array containing a list of files to download
# Loop through the array and download each corresponding file using wget

fileList=(
    'Image_Video_Uploader.psd'
    'Magento-icon-library.ai'
    'Magento_Row_pattern_src.zip'
    'Magento_expandable_section.zip'
    'Magento_icon_grid_300x300.ai'
    'Magento_select_from_list_srce.zip'
    'MigrationToolInternalSpecification.pdf'
    'Modal.psd'
    'RWD_icon_sprite.psd'
    'RWD_social_icons.psd'
    'Scheduled-Changes-Module-Source.psd'
    'Slide-out-Panels.psd'
    'Variation1.psd'
    'Variation2.psd'
    'Variation3.psd'
    'Variation4.psd'
    'datatable-pattern-styles.zip'
    'date&timepicker.psd'
    'defaultconfig.psd'
    'filter-data-table.zip'
    'forms_pattern.zip'
    'magento-button-bar.psd'
    'magento-buttons.psd'
    'magento-commerce-cloud-prelaunch-checklist.pdf'
    'magento-links.psd'
    'magento-progressbar.zip'
    'magento-sign-in.psd'
    'magento-static-content-container.psd'
    'magento-tabs.psd'
    'magento-tree-pattern.zip'
    'magento-viewcontrol.psd'
    'magento_icon_library.sketch'
    'tile-pattern-styles.psd'
    'tile-pattern-styles.psd.zip'
    'timeline-dashboard.psd'
    'wizard-pattern-styles.psd'
  )

for val in ${fileList[@]}; do
    wget https://devdocs.magento.com/download/$val
done