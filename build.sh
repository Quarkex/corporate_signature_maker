#!/bin/bash

      ############################
     # mail signature generator #
    ############################

    #############################################################
    #                                                           #
    # This script generates corporative mail signatures         #
    # based on the contents of the folder “in” and writes       #
    # them to the folder “out”.                                 #
    #                                                           #
    # The output will be images in PNG and htm files with       #
    # the images encoded in base64, ready to copy and paste     #
    # directly to the mail signature text box.                  #
    #                                                           #
    # Input files are simple text files with the filename       #
    # structure “<job position> - <full name>.txt” and the      #
    # contents should be the mail in its first line, phone 1    #
    # in the second and phone 2 in the third.                   #
    #                                                           #
    # The base image is in the img folder, named “base.png”.    #
    #                                                           #
    # This script requires imagemagick to work. To install      #
    # it in Ubuntu-like systems: “sudo apt install imagemagick” #
    #                                                           #
    # Fonts required should be in the “fonts” folder. They are  #
    # “arial.tty” and “arial-bold.tty”.                         #
    #                                                           #
    #############################################################

caption_line_1="Consiga el control total de su Empresa o"
caption_line_2="negocio y mejore sus resultados usando la"
caption_line_3="Tecnología."

for file in in/*.txt; do
    filename="${file%%.txt}"
    filename="${filename##*/}"
    name="${filename##* - }"
    job="${filename%% - *}"
    i=0
    while read line; do
        if [[ $i == 0 ]]; then
            mail="$line"
        fi
        if [[ $i == 1 ]]; then
            phone1="$line"
        fi
        if [[ $i == 2 ]]; then
            phone2="$line"
        fi
        let i=$(( i + 1 ));
    done<"$file"

    if [[ -f "out/$job - $name.png" ]]; then
        rm "out/$job - $name.png"
    fi
    convert img/base.png \
        -font fonts/arial_bold.ttf \
        -fill black \
        -pointsize 16 \
        -annotate +235+40 "$name"\
        -font fonts/arial.ttf \
        -fill gray \
        -pointsize 15 \
        -annotate +235+58 "$job"\
        -pointsize 10 \
        -annotate +340+106 "$phone1"\
        -annotate +340+119 "$phone2"\
        -pointsize 11 \
        -annotate +441+113 "$mail"\
        -pointsize 16 \
        -font fonts/arial.ttf \
        -fill black \
        -annotate +565+40 "$caption_line_1"\
        -annotate +565+64 "$caption_line_2"\
        -annotate +565+88 "$caption_line_3"\
        "out/$job - $name.png"
    image="$(cat "out/$job - $name.png" | base64 | paste -s -d' ')"
    cat << EOF > "out/$job - $name.htm"
<p>Le saluda,</p>
<img style='display:block; width:879px;height:127px;' src='data:image/png;base64,${image}' />
<p>Aviso legal: Este mensaje se dirige exclusivamente a su destinatario y puede contener información privilegiada o confidencial. Si no es vd. el destinatario indicado, queda notificado que la utilización, divulgación y/o copia sin autorización está prohibida  en virtud de la legislación vigente. Si ha recibido este mensaje por error, le rogamos que nos lo comunique inmediatamente por esta misma vía y proceda a su destrucción.</p>
<p>Canarias Infopista S.L respeta la confidencialidad de sus datos. De conformidad con el Reglamento General de Protección de Datos (RGPD) le informamos que sus datos forman parte de un fichero propiedad de  Canarias Infopista S.L ,si no desea recibir más comunicaciones nuestras por esta vía o simplemente desea ejercitar sus derechos de acceso, rectificación, oposición, limitación, portabilidad y supresión, puede enviar esta comunicación, junto con prueba válida en derecho como su DNI, con el asunto: Ejercicio de derechos, a la dirección electrónica: administracion@cip.es.</p>
EOF
done

