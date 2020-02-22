#! /usr/bin/gawk
# 01_Sonate_fur_Klavier_Nr29_Hammerklavier_B_Dur_Op106.awk

# ------------------------------------------------------------------------------------------------------------------------

# Copyright 2019 The LOTLTHNBR Project Authors, GinSanaduki.
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
# TB3DS Scripts provides a function to obtain a list of teachers became a disciplinary dismissal disposal
# and to inquire by license number.
# This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later 
# and BusyBox developed by Erik Andersen, Rob Landley, Denys Vlasenko and others.
# GAWK 5.0.1 Download ezwinports from SourceForge.net
# https://sourceforge.net/projects/ezwinports/files/gawk-5.0.1-w32-bin.zip/download
# BusyBox Official
# https://www.busybox.net/
# BusyBox -w32
# http://frippery.org/busybox/
# Download
# http://frippery.org/files/busybox/busybox.exe
# BusyBox Wildcard expansion
# https://frippery.org/busybox/globbing.html
# Download
# https://frippery.org/files/busybox/busybox_glob.exe

# ------------------------------------------------------------------------------------------------------------------------

@include "AWKScripts/01_UPDATE/02_CommonParts/01_Konzertouverture.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/02_Allegro.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/03_TelecommunicationControl.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/04_FileUtils.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/05_AssaiVivace.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/06_AdagioSostenuto.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/07_Introduzione.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/08_Largo.awk";
@include "AWKScripts/01_UPDATE/02_CommonParts/09_AllegroRisoluto.awk";

# ------------------------------------------------------------------------------------------------------------------------

BEGIN{
	print "Sonate fur Klavier Nr.29 Hammerklavier B-Dur Op.106 will commence shortly.";
	print "START Konzertouverture...";
	Konzertouverture();
	print "END Konzertouverture.";
	print "START Allegro...";
	Allegro();
	print "END Allegro.";
	print "START AssaiVivace...";
	AssaiVivace();
	print "END AssaiVivace.";
	print "START AdagioSostenuto...";
	AdagioSostenuto();
	print "END AdagioSostenuto.";
	exit
	print "START Introduzione...";
	Conductor_XLSX = Introduzione();
	print "END Introduzione.";
	print "START Largo...";
	Largo(Conductor_XLSX);
	print "END Largo.";
	print "START AllegroRisoluto...";
	AllegroRisoluto(Conductor_XLSX);
	print "END AllegroRisoluto.";
	print "That's all, folks...";
}

