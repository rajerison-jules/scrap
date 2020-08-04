require 'rubygems'
require 'nokogiri'
require 'open-uri'

$url = "http://www2.assemblee-nationale.fr" # URL de base

# recuperer les href.text pour aller a chaque page de profil des deputes
doc = Nokogiri::HTML(URI.open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
href = doc.css('a[href]')
href_arr = href.map{|link| link['href']}.select{|link| link.match("/deputes/fiche/OMC")}

# reconstituer le lien complet (URL de base + href text)
def full_link(arr)
  arr.map do |link|
    $url + link
  end
end

# stocker les liens pour acceder a chaque page de profil des deputes
depute_links = full_link(href_arr)

# Pour recuperer le nom de chaque personne
def get_name(url)
  doc = Nokogiri::HTML(URI.open(url))
  name_text = doc.css('.titre-bandeau-bleu h1').text
  return name_text
end

# Pour recuperer l'email de chaque personne
def get_email(url)
  doc = Nokogiri::HTML(URI.open(url))
  mail_href = doc.css('.deputes-liste-attributs a[href]')[2]
  if mail_href == nil 
    return nil
  else
    mail = mail_href.text
    return mail
  end
end

# Pour afficher le resultat
depute_links.map do |element|
  result = []
  result << {"Name" => get_name(element), "Email" => get_email(element)}
  puts result
end

=begin
  IL Y EXISTE 576 DEPUTES EN FRANCE 
  ALORS LE RESULTAT VAS PRENDRE DU TEMPS POUR ETRE AFFICHER COMPLETEMENT
  SI VOUS ETES IMPATIENT ET NE VEUT PAS ALLER JUSQU'A LA FIN, TAPER CTRL+C DANS LE TERMINAL
=end