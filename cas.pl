#! /usr/bin/perl  #non
open RESULT, "result.csv" or die "Can't open the result.csv:$!"; 
open LAST, ">> lastresult.csv" or die "Can't open the lastresult:$!"; 
while (<RESULT>) {
	chomp;
	@result=split(",",$_); 
	$name=join("_",join(".",$result[0],"faa"),join(".",$result[1],"HMM")); 
	$proname=join(".","$result[0]","ptt"); 
	$hmmname=$result[1]; 
	$infoname=join(".",$result[1],"INFO"); 
	open SINGLE, "$name" or die "Can't open the every result file:$!";
	while (<SINGLE>) {
		chomp;
		if (/^gi/) {
			s/,/;/g; 
			/(?<=gi\|)[0-9]*/; 
			$numofgi=$&; 
			/([0-9]+)\s+(\w+)\s+(\w+)\s+([0-9]+)\s+([0-9]+|[0-9]+\.\w+\-\w+|\w+\-\w+|[0-9]+\.[0-9]+|\w+\.\w+\+\w+|\w+\+\w+)\s+(\w+\.\w+|\-\w+\.\w+)\s+(\w+\.\w+|\-\w+\.\w+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+|[0-9]+\.\w+\-\w+|\w+\-\w+|[0-9]+\.[0-9]+|\w+\.\w+\+\w+|\w+\+\w+)\s+([0-9]+|[0-9]+\.\w+\-\w+|\w+\-\w+|[0-9]+\.[0-9]+|\w+\.\w+\+\w+|\w+\.\w+\+\w+|\w+\+\w+)\s+(\w+\.\w+|\-\w+\.\w+)\s+(\w+\.\w+|\-\w+\.\w+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+(\w+\.\w+)/; 
			$tlen=$1;
			$query_name=$2;
			$accession=$3;
			$qlen=$4;
                        $full_sequence_evalue=$5;
			$full_sequence_score=$6;
			$full_sequnece_bias=$7;
			$this_domain_no=$8;
			$this_domain_of=$9;
			$this_domain_cvalue=$10;
			$this_domain_ievalue=$11;
			$this_domain_score=$12;
			$this_domain_bias=$13;
			$hmm_coord_from=$14;
			$hmm_coord_to=$15;
			$ali_coord_from=$16;
			$ali_coord_to=$17;
			$env_coord_from=$18;
			$env_coord_to=$19;
			$acc=$20;
			open PROFILE, "$proname" or die "Can't open the profile:$!"; 
			while (<PROFILE>) {
				chomp;
                                if (/$numofgi/) { 
					   s/,/;/g;
				           /([0-9]+)\.\.([0-9]+)\s+(\+|\-)\s+([0-9]+)\s+([0-9]+)\s+(\-|\w+)\s+(\w+\_\w+|\w+|\w+\.\w+)\s+(\-|\w+)\s+(\-|\w+)\s+(.+)/; 
				           $ptt_location_from=$1;
				           $ptt_location_to=$2;
                                           $ptt_strand=$3;
				           $ptt_length=$4;
                                           $ptt_pid=$5;
				           $ptt_gene=$6;
			                   $ptt_synonym=$7;
				           $ptt_code=$8;
				           $ptt_cog=$9;
				           $ptt_product=$10;
			        }
                        }
			close PROFILE;
			open TIGRCAS, "tigr_cas" or die "Can't open the tigr_cas file: $!";
			while (<TIGRCAS>) {
				chomp;
				@tigrcas=split(" ",$_);
				if ($tigrcas[1] eq $hmmname) {
					$casname=$tigrcas[0];
				}
			}
			close TIGRCAS;
			open INFO, "$infoname" or die "Can't open the infofile:$!";
			while (<INFO>) {
				chomp;
				if (/^DE/) {
				         s/,/;/g;
			         	/DE\s+(.+)/;
			        	$info_de=$1;
				}
				if (/^TC/) {
				        /TC\s+([0-9]+|[0-9]+\.[0-9]+)\s+([0-9]+|[0-9]+\.[0-9]+)/;
			         	$info_tc_globl=$1;
			        	$info_tc_domain=$2;
				}
				if (/^NC/) {
				        /NC\s+([0-9]+|[0-9]+\.[0-9]+)\s+([0-9]+|[0-9]+\.[0-9]+)/;
				        $info_nc_globl=$1;
				        $info_nc_domain=$2;
				}
			}
			close INFO;
		        print LAST "$casname,$result[0],$result[1],$ptt_location_from,$ptt_location_to,$ptt_strand,$ptt_length,$ptt_pid,$ptt_gene,$ptt_synonym,$ptt_code,$ptt_cog,$ptt_product,$numofgi,$tlen,$query_name,$accession,$qlen,$full_sequence_evalue,$full_sequence_score,$full_sequnece_bias,$this_domain_no,$this_domain_of,$this_domain_cvalue,$this_domain_ievalue,$this_domain_score,$this_domain_bias,$hmm_coord_from,$hmm_coord_to,$ali_coord_from,$ali_coord_to,$env_coord_from,$env_coord_to,$acc,$info_de,$info_tc_globl,$info_tc_domain,$info_nc_globl,$info_nc_domain\n";
		 }
	}
	close SINGLE;
}
close RESULT;
close LAST;
