#encoding=utf-8
class Oca::GetPdfDeEtiquetasPorOrdenOrNumeroEnvio < Oca::Base

  # p = Oca::GetPdfDeEtiquetasPorOrdenOrNumeroEnvio.new(IdOrdenRetiro: 38283012, nroEnvio: 2320800000000000087, logisticaInversa: false)
  def initialize(options = {})
    @IdOrdenRetiro    = options[:IdOrdenRetiro]
    @nroEnvio         = options[:nroEnvio]
    @logisticaInversa = options[:logisticaInversa]
    super(options)
  end

  def submit
    if valid?
      result = self.class.post(
        "/oep_tracking/Oep_Track.asmx",
        body: data
        )

      return unless result.body

      h = Hash.from_xml(result.body)
      h["Envelope"].try(:[], "Body").try(:[], "GetPdfDeEtiquetasPorOrdenOrNumeroEnvioResponse")
    else
      false
    end
  end

  private
    def data
      body = <<-EOF
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:oca="#Oca_Express_Pak">
   <soap:Header/>
   <soap:Body>
      <oca:GetPdfDeEtiquetasPorOrdenOrNumeroEnvio>
         <oca:idOrdenRetiro>#{@IdOrdenRetiro}</oca:idOrdenRetiro>
         <!--Optional:-->
         <oca:nroEnvio>#{@nroEnvio}</oca:nroEnvio>
         <oca:logisticaInversa>#{@logisticaInversa}</oca:logisticaInversa>
      </oca:GetPdfDeEtiquetasPorOrdenOrNumeroEnvio>
   </soap:Body>
</soap:Envelope>
    EOF
    end
end
