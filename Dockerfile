# Copyright (c) 2018-present Ark
# Released under the MIT license
# https://opensource.org/licenses/MIT

FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV YEAR "2021"
ENV PATH="/usr/local/texlive/${YEAR}/bin/x86_64-linux:$PATH"


RUN apt-get update \
    && apt-get -y install \
        build-essential \
        ghostscript \
        git \
        gosu \
        libfontconfig1-dev \
        libfreetype6-dev \
        locales-all \
        perl \
        python3-dev \
        python3-pip \
        wget \
        inkscape \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install pygments \
    && cpan YAML::Tiny \
    && cpan File::HomeDir \
    && cpan Unicode::GCString \
    && mkdir /tmp/install-tl-unx \
    && wget -O - ftp://tug.org/historic/systems/texlive/${YEAR}/install-tl-unx.tar.gz \
        | tar -xzv -C /tmp/install-tl-unx --strip-components=1 \
    && /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
        > /tmp/install-tl-unx/texlive.profile \
    && /tmp/install-tl-unx/install-tl \
        --profile /tmp/install-tl-unx/texlive.profile \
    && rm -r /tmp/install-tl-unx \
    && tlmgr update --self \
    && tlmgr install \
        collection-bibtexextra \
        collection-fontsrecommended \
        collection-langenglish \
        collection-langjapanese \
        collection-latexextra \
        collection-latexrecommended \
        collection-luatex \
        collection-mathscience \
        collection-plaingeneric \
        collection-xetex \
        latexdiff \
        latexindent \
        latexmk \
        pdfcrop \
    && mkdir /tmp/latexmk

COPY .latexmkrc /tmp/latexmk/

COPY bin/entrypoint.sh /usr/local/bin/

COPY bin/latexmk-ext /usr/local/bin/

WORKDIR /workdir

ENTRYPOINT ["entrypoint.sh"]

CMD ["latexmk-ext"]
