WORKFLOW_STATUSES=("NEW" "NOTIFIED" "RESOLVED")
RECORD_STATE="ACTIVE"
ACCOUNT_IDS=("133452444714" "916775992448")
RESOURCE_TYPE="AwsEcrContainerImage"

# Función para obtener y actualizar hallazgos
update_findings() {
    for ACCOUNT_ID in "${ACCOUNT_IDS[@]}"; do
        # Construir el JSON de filtros
        FILTERS_JSON=$(cat <<EOF
{
    "AwsAccountId": [{"Value": "$ACCOUNT_ID", "Comparison": "EQUALS"}],
    "ResourceType": [{"Value": "$RESOURCE_TYPE", "Comparison": "EQUALS"}],
    "WorkflowStatus": [
        {"Value": "NEW", "Comparison": "EQUALS"},
        {"Value": "NOTIFIED", "Comparison": "EQUALS"},
        {"Value": "RESOLVED", "Comparison": "EQUALS"}
    ],
    "RecordState": [{"Value": "$RECORD_STATE", "Comparison": "EQUALS"}],
    "SeverityLabel": [
        {"Value": "HIGH", "Comparison": "EQUALS"}
    ]
}
EOF
)

                # Obtener los IDs de los hallazgos que coinciden con los criterios y formatear la salida como JSON
        FINDINGS_IDS_JSON=$(aws securityhub get-findings --filters "$FILTERS_JSON" --query "Findings[].{Id: Id, ProductArn: ProductArn}" --output json)

        # Verificar si se encontraron hallazgos
        if [ -z "$FINDINGS_IDS_JSON" ] || [ "$FINDINGS_IDS_JSON" == "[]" ]; then
            echo "No se encontraron hallazgos para actualizar para la cuenta $ACCOUNT_ID."
            continue
        fi

        # Utilizar jq para formatear correctamente la salida JSON para el comando batch-update-findings
        FINDINGS_IDS=$(echo $FINDINGS_IDS_JSON | jq -c '.[]')
        
        # Verificar si jq produjo una salida vacía
        if [ -z "$FINDINGS_IDS" ]; then
            echo "Error al procesar los hallazgos para la cuenta $ACCOUNT_ID."
            continue
        fi

        # Iterar sobre cada hallazgo y actualizarlo individualmente
        echo "$FINDINGS_IDS" | while read FINDING; do
            echo "Actualizando el hallazgo $FINDING para la cuenta $ACCOUNT_ID a SUPPRESSED..."
            aws securityhub batch-update-findings --finding-identifiers "[$FINDING]" --workflow Status=SUPPRESSED --no-cli-pager
        done
    done
}

# Llamar a la función para actualizar los hallazgos
update_findings