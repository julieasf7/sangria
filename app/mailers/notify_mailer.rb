class NotifyMailer < ApplicationMailer
	default from: "sangrianotify@gmail.com"

	def welcome_email(user)
		@user = user
		message = 'Hi ' + @user.name + '! Welcome to Sangria.'
		mail(to: @user.email, subject: message)
	end

	def followup_reminder(user, interaction)
		@user = user
		@interaction = interaction
		message = 'Have you followed-up after ' + @interaction.title
		mail(to: @user.email, subject: message)
	end
end
