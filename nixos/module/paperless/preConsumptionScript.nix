{ pkgs, passwordFile }:

pkgs.writeShellApplication {
  name = "pdf-decrypt";
  runtimeInputs = with pkgs; [
    qpdf
    gnugrep
    coreutils-full
  ];
  text = ''
    PASSWORD_FILE="${passwordFile}"

    # Check environment variable
    if [[ -z "$DOCUMENT_WORKING_PATH" ]]; then
        echo "Error: DOCUMENT_WORKING_PATH not set." >&2
        exit 1
    fi

    # Check if file exists
    if [[ ! -f "$DOCUMENT_WORKING_PATH" ]]; then
        echo "Error: File not found." >&2
        exit 1
    fi

    # Check if it's a PDF
    if [[ "''${DOCUMENT_WORKING_PATH,,}" != *.pdf ]]; then
        echo "Not a PDF file. Skipping."
        exit 0
    fi

    # Check if PDF is encrypted
    if qpdf --show-encryption "$DOCUMENT_WORKING_PATH" 2>/dev/null | grep -q "File is not encrypted"; then
        echo "$DOCUMENT_WORKING_PATH not encrypted."
        exit 0
    fi

    # Read password
    if [[ ! -f "$PASSWORD_FILE" ]]; then
        echo "Error: Password file not found." >&2
        exit 1
    fi

    password=$(cat "$PASSWORD_FILE" | tr -d '\n\r')

    if [[ -z "$password" ]]; then
        echo "Error: Password file empty." >&2
        exit 1
    fi

    # Decrypt PDF
    if qpdf --password="$password" --decrypt --replace-input "$DOCUMENT_WORKING_PATH"; then
        echo "$DOCUMENT_WORKING_PATH decrypted successfully."
    else
        echo "Error: Failed to decrypt $DOCUMENT_WORKING_PATH." >&2
        exit 1
    fi
  '';
}
