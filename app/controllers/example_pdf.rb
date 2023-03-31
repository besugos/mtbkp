# class ReportReviewModelPdf < Prawn::Document

# 	# Exemplo projeto Resenha
# 	def initialize(review)
# 		super(top_margin: -20)
# 		@review = review
# 		@cursor = cursor
# 		@default_red_color = 'F78181'
# 		@default_white_color = 'FFFFFF'
# 		@default_black_color = '000000'
# 		@default_size_font = 7
# 		@default_size_font_fill = 8
# 		@default_distance_x_header = -60
# 		@default_height_table = 15
# 		# Título
# 		data_title
# 		# Cabeçalho
# 		data_header
# 		# Proprietário
# 		data_table_owner
# 		fill_data_owner
# 		# Animal
# 		data_table_animal
# 		fill_data_animal
# 		# Resenha
# 		data_review_table
# 		# Descrição do Animal
# 		data_description_review_table
# 		# Finalidade
# 		data_finality_review_table
# 		# Assinatura
# 		data_signature_table
# 	end

# 	# Título
# 	def data_title
# 		bounding_box([0,740], :width => 548, :height => 30) do
# 			stroke_color @default_red_color
# 			fill_color @default_red_color
# 			stroke_bounds
# 			text_box 'REQUISIÇÃO PARA DIAGNÓSTICO DE MORMO e/ou ANEMIA INFECCIOSA EQUINA', 
# 			:size => 10, at: [90,25], align: :center, style: :bold, width: 370
# 		end
# 	end

# 	# Cabeçalho
# 	def data_header
# 		bounding_box([0,710], :width => 548, :height => 100) do
# 			stroke_color @default_red_color
# 			stroke_bounds
# 			# Parte esquerda
# 			header_left
# 			# Parte direita
# 			header_right
# 		end
# 	end

# 	# Parte esqueda do cabeçalho
# 	def header_left
# 		if !@review.laboratory.nil?
# 			if !@review.laboratory.attachment.nil?
# 				# logo
# 				image open(@review.laboratory.attachment.attachment.url), at: [40,98], :position => :left, width: 90, height: 45
# 			end
# 			if !@review.laboratory.address.nil? 
# 				text_box @review.laboratory.address.get_address_value, at: [@default_distance_x_header+10,50], size: @default_size_font, width: 450, align: :center, color: @default_red_color
# 			end
# 			text_box 'Telefone: '+@review.laboratory.phone+' - Site: '+@review.laboratory.site+' - E-mail: '+@review.laboratory.email, at: [@default_distance_x_header,40], size: @default_size_font, width: 470, align: :center
# 			text_box 'Responsável Técnico (a): '+@review.laboratory.responsible+' / CRMV-'+@review.user.mormo_uf.acronym+' '+@review.user.crmv+' - E-mail: '+@review.user.email, at: [@default_distance_x_header,30], size: @default_size_font, width: 470, align: :center
# 		end
# 	end

# 	# Parte direita do cabeçalho
# 	def header_right
# 		text_box 'CREDENCIADO MAPA Ministério da Agricultura, Pecuária e Abastecimento - ', at: [205,95], size: @default_size_font, width: 350
# 		text_box 'Portaria Nº 172 de 23/07/2014', at: [445,95], size: @default_size_font, width: 350, style: :bold
# 		text_box 'D.O.U.: Nº 141, de 25/07/2014, seção 1, pág.: 11', at: [210,85], size: @default_size_font, width: 350, align: :center
# 		text_box 'Nº do Exame', at: [270,72], size: 12, width: 350, align: :center, style: :bold
# 		bounding_box([360,60], :width => 165, :height => 30) do
# 			stroke_color @default_red_color
# 			stroke_bounds
# 		end
# 		text_box 'Série A:', at: [204,15], size: 10, width: 350, align: :center, style: :bold
# 		fill_color @default_black_color
# 		text_box 'Nº '+@review.identifier.to_s, at: [255, 22], size: 20, width: 350, align: :center, style: :italic
# 		fill_color @default_red_color
# 	end

# 	# Tabela do proprietário
# 	def data_table_owner
# 		table owner_table, width: 548, :cell_style => {height: @default_height_table, border_color: @default_red_color, size: @default_size_font, padding: 8 } do
			
# 			style(row(0).column(0), padding: [2,0,0,5], border_top_width: 2, border_left_width: 2)
# 			style(row(0).column(1), padding: [2,0,0,5], border_top_width: 2)
# 			style(row(0).column(2), padding: [2,0,0,5], border_top_width: 2, border_right_width: 2)
			
# 			style(row(1).column(0), width: 200, padding: [2,0,0,5], border_left_width: 2, border_right_width: 2)

# 			style(row(2).column(0), padding: [2,0,0,5], border_left_width: 2)
# 			style(row(2).column(1), padding: [2,0,0,5])
# 			style(row(2).column(2), padding: [2,0,0,5], border_right_width: 2)
			
# 			style(row(3).column(0), padding: [2,0,0,5], border_left_width: 2)
# 			style(row(3).column(1), padding: [2,0,0,5])
# 			style(row(3).column(2), padding: [2,0,0,5], border_right_width: 2)

# 			style(row(4), padding: [2,0,0,5], border_left_width: 2, border_bottom_width: 2, border_right_width: 2)
# 		end
# 	end

# 	def owner_table
# 		[
# 			[{ content: 'Proprietário do Animal:', colspan: 1, width: 200 }, { content: 'CPF:', colspan: 1 }, { content: 'Telefone:', colspan: 1 }],
# 			[{ content: 'Endereço Completo do Proprietário do Animal:', colspan: 3 }],
# 			[{ content: 'Médico Veterinário Requisitante:', colspan: 1}, { content: 'CPF:', colspan: 1 }, { content: 'CRMV/UF:', colspan: 1 }],
# 			[{ content: 'E-mail:', colspan: 1, width: 80}, { content: 'Telefone:'}, { content: 'Nº da Portaria de Habilitação:' }],
# 			[{ content: 'Endereço Completo:', colspan: 3 }],
# 		]
# 	end

# 	def fill_data_owner
# 		fill_color @default_black_color
# 		if !@review.owner.nil?
# 			text_box @review.owner.name, at: [80,605], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.owner.cpf, at: [285,605], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.owner.phone, at: [415,605], size: @default_size_font_fill, width: 350, align: :left

# 			if !@review.owner.address.nil?
# 				text_box @review.owner.address.get_address_value, at: [160,590], size: @default_size_font_fill, width: 750, align: :left
# 			end
# 		end

# 		if !@review.user.nil?
# 			text_box @review.user.name, at: [110,575], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.user.cpf, at: [290,575], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.user.crmv_value, at: [420,575], size: @default_size_font_fill, width: 350, align: :left

# 			text_box @review.user.email, at: [30,560], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.user.get_first_phone, at: [295,560], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.user.get_mormo_value, at: [480,560], size: @default_size_font_fill, width: 350, align: :left

# 			if !@review.user.address.nil?
# 				text_box @review.user.address.get_address_value, at: [80,545], size: @default_size_font_fill, width: 600, align: :left
# 			end
# 		end
# 		fill_color @default_red_color
# 	end

# 	# Tabela do animal
# 	def data_table_animal
# 		table animal_table, width: 548, :cell_style => {height: @default_height_table, border_color: @default_red_color, size: @default_size_font, padding: 8 } do
			
# 			style(row(0).column(0), padding: [2,0,0,5], border_top_width: 2, border_left_width: 2)
# 			style(row(0).column(1), padding: [2,0,0,5], border_top_width: 2)
# 			style(row(0).column(2), padding: [4,0,0,5], size: 7, style: :bold, align: :center, border_top_width: 2, border_right_width: 2)		

# 			style(row(1).column(0), padding: [2,0,0,5], border_left_width: 2)
# 			style(row(1).column(1), padding: [2,0,0,5])
# 			style(row(1).column(2), padding: [2,0,0,5], border_right_width: 2)
			
# 			style(row(2).column(0), padding: [2,0,0,5], border_left_width: 2)
# 			style(row(2).column(1), padding: [2,0,0,5])
# 			style(row(2).column(2), padding: [2,0,0,5], border_right_width: 2)
			
# 			style(row(3).column(0), padding: [2,0,0,5], border_left_width: 2)
# 			style(row(3).column(1), padding: [2,0,0,5])
# 			style(row(3).column(2), padding: [2,0,0,5], border_right_width: 2)
			
# 			style(row(4).column(0), padding: [2,0,0,5], border_left_width: 2)
# 			style(row(4).column(1), padding: [2,0,0,5])
# 			style(row(4).column(2), padding: [2,0,0,5], border_right_width: 2)
			
# 		end
# 	end

# 	def animal_table
# 		[
# 			[{ content: 'Nome do Animal:', colspan: 1, width: 200 }, { content: 'Registro Nº / Marca:', colspan: 1 }, { content: 'CLASSIFICAÇÃO:', colspan: 1, rowspan: 2 }],
# 			[{ content: 'Espécie:', colspan: 1 }, { content: 'Raça:', colspan: 1 }],
# 			[{ content: 'Sexo:', colspan: 1 }, { content: 'Idade:', colspan: 1 }, { content: 'Gestação:', colspan: 1 }],
# 			[{ content: 'Propriedade onde se encontra:', colspan: 1 }, { content: 'Nº do Cadastro Estadual:', colspan: 1 }, { content: 'Nº de Equídeos existentes:', colspan: 1, rowspan: 2 }],
# 			[{ content: 'Município/UF:', colspan: 1 }, { content: 'Telefone:', colspan: 1 }],
# 		]
# 	end

# 	def fill_data_animal
# 		fill_color @default_black_color
# 		if !@review.animal.nil?
# 			text_box @review.animal.name, at: [65,531], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.animal.register_number, at: [325,531], size: @default_size_font_fill, width: 350, align: :left

# 			if !@review.animal.animal_kind.nil? 
# 				text_box @review.animal.animal_kind.name, at: [40,515], size: @default_size_font_fill, width: 350, align: :left
# 			end
# 			text_box @review.animal.breed, at: [280,515], size: @default_size_font_fill, width: 350, align: :left

# 			text_box @review.animal.get_sex, at: [35,500], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.animal.get_age.to_s, at: [280,500], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.animal.get_gestation, at: [440,500], size: @default_size_font_fill, width: 350, align: :left

# 			text_box @review.animal.coat, at: [55,430], size: 14, width: 350, align: :left

# 		end

# 		if !@review.property.nil?
# 			if !@review.property.property_classification.nil? 
# 				text_box @review.property.property_classification.name, at: [445,517], size: @default_size_font_fill, width: 350, align: :left
# 			end

# 			text_box @review.property.name, at: [105,485], size: @default_size_font_fill, width: 350, align: :left
# 			text_box @review.property.state_registration_number, at: [335,485], size: @default_size_font_fill, width: 350, align: :left

# 			if !@review.property.address.nil?
# 				text_box @review.property.address.get_city_and_state, at: [60,470], size: @default_size_font_fill, width: 350, align: :left
# 			end
# 			text_box @review.property.phone, at: [290,470], size: @default_size_font_fill, width: 350, align: :left

# 			text_box @review.property.equines_number.to_s, at: [450,475], size: 12, width: 350, align: :left
# 		end

# 		text_box @review.finality, at: [150,140], size: 12, width: 350, align: :left
# 		if !@review.disease.nil?
# 			text_box @review.disease.name, at: [395,140], size: 12, width: 350, align: :left
# 		end

# 		fill_color @default_red_color
# 	end
	
# 	# Tabela do animal
# 	def data_review_table
# 		table review_table, width: 548, :cell_style => {height: 230, border_color: @default_red_color, size: @default_size_font, padding: 8 } do
# 			style(row(0), padding: [2,0,0,55], width: 100, style: :bold, size: 14, border_top_width: 2, border_right_width: 2, border_left_width: 2)
# 		end
# 		bounding_box([10,440], :width => 165, :height => 30) do
# 			stroke_color @default_red_color
# 			stroke_bounds
# 		end
# 		text_box 'Pelagem:', at: [12,437], size: @default_size_font, width: 350, align: :left
# 	end

# 	def review_table
# 		[
# 			[{ content: 'RESENHA', colspan: 3, align: :left}]
# 		]
# 	end

# 	# Tabela descrição
# 	def data_description_review_table
# 		move_down 180
# 		table description_review_table, width: 548, :cell_style => {height: 80, border_color: @default_red_color, size: @default_size_font, padding: 8 } do
# 			style(row(0), padding: [2,0,0,5], border_right_width: 2, border_left_width: 2)
# 		end
# 	end

# 	def description_review_table
# 		[
# 			[{ content: 'Descrição do Animal:', colspan: 3, align: :left}]
# 		]
# 	end

# 	# Tabela finalidade
# 	def data_finality_review_table
# 		table finality_review_table, width: 548, :cell_style => {align: :left, height: 26, border_color: @default_red_color, size: 15} do
# 			style(row(0), padding: [5,0,0,2], style: :bold)
# 		end
# 	end

# 	def finality_review_table
# 		[
# 			[{ content: 'Finalidade do Exame:', width: 274.5, border_left_width: 2, border_bottom_width: 2}, { content: 'Exame para:', border_bottom_width: 2, border_right_width: 2}]
# 		]
# 	end

# 	# Tabela Assinatura
# 	def data_signature_table
# 		table header_signature_table, width: 548, :cell_style => {background_color: @default_red_color, align: :center, height: 15, border_color: @default_red_color, size: 10, padding: 8 } do
# 			style(row(0), padding: [1,0,0,5], style: :bold)
# 			style(row(0).column(1), padding: [1,0,0,5], style: :bold)
# 		end
# 		table signature_table, width: 548, :cell_style => {height: 109, border_color: @default_red_color, size: 10, padding: 8 } do
# 		end
# 		texts_signature
# 	end

# 	def header_signature_table
# 		[
# 			[{ content: 'REQUISITANTE', border_left_width: 2, border_bottom_width: 2, border_right_width: 1, text_color: @default_white_color }, {content: 'LABORATÓRIO', width: 190, border_left_width: 1, border_bottom_width: 2, border_right_width: 2, text_color: @default_white_color}]
# 		]
# 	end

# 	def signature_table
# 		[
# 			[{ content: '', width: 350, border_left_width: 2, border_bottom_width: 2}, { content: '', border_bottom_width: 2, border_right_width: 2}]
# 		]
# 	end

# 	# Textos do card de assinatura
# 	def texts_signature
# 		text_box 'O animal foi inspecionado, por mim nesta data:', at: [5,105], size: @default_size_font, width: 350, align: :left
# 		text_box '____________________________________ , _________ de _______________________ de ____________', at: [5,70], size: @default_size_font, width: 350, align: :left
# 		text_box 'Local e data', at: [0,60], size: @default_size_font, width: 350, align: :center
# 		text_box '________________________________________________________________________________________', at: [5,35], size: @default_size_font, width: 350, align: :left
# 		text_box 'Assinatura e Carimbo do Médico Veterinário Requisitante', at: [0,26], size: @default_size_font, width: 350, align: :center

# 		text_box 'Relatório de ensaio emitido conforme Portaria nº 35/2018', at: [350,60], size: 8, style: :bold, width: 200, align: :center
# 	end

# end
