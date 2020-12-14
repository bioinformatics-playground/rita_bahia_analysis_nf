nextflow.enable.dsl = 2

import java.nio.file.Paths

include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"
include { RD_ANALYZER } from "./modules/rd_analyzer/rd_analyzer.nf"
include { SPOTYPING } from "./modules/spotyping/spotyping.nf"
include { SPADES } from "./modules/spades/spades.nf"
include { PROKKA } from "./modules/prokka/prokka.nf"
include { MTBSEQ } from "./modules/mtbseq/mtbseq.nf"
include { UNICYCLER } from "./modules/unicycler/unicycler.nf"

//include { RAXML } from "./modules/prokka/prokka.nf"

workflow {

    sra_ids_ch = Channel.fromSRA(params.sra_ids, cache: true, apiKey: params.ncbi_api_key)
    gatk38_jar_ch = Channel.value(Paths.get(params.gatk38_jar))
    env_user_ch = Channel.value("root")

    TRIMMOMATIC(sra_ids_ch)
    UNICYCLER(TRIMMOMATIC.out)
    MTBSEQ(TRIMMOMATIC.out,
            gatk38_jar_ch,
            env_user_ch)
    RD_ANALYZER(TRIMMOMATIC.out)
    SPOTYPING(TRIMMOMATIC.out)
    SPADES(TRIMMOMATIC.out)
    PROKKA(SPADES.out)

}

workflow test {
    sra_ids_ch = Channel.fromSRA(params.sra_ids, cache: true, apiKey: params.ncbi_api_key)
    gatk38_jar_ch = Channel.value(Paths.get(params.gatk38_jar))
    env_user_ch = Channel.value("root")

    TRIMMOMATIC(sra_ids_ch) // DONE
    UNICYCLER(TRIMMOMATIC.out) // DONE
    MTBSEQ(TRIMMOMATIC.out,
            gatk38_jar_ch,
            env_user_ch) // DONE
    RD_ANALYZER(TRIMMOMATIC.out) // DONE
    SPOTYPING(TRIMMOMATIC.out) // DONE
    SPADES(TRIMMOMATIC.out) // DONE
    PROKKA(SPADES.out) // DONE


// TODO
//   RAXML()


}

