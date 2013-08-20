require($root+'system/xmvc/xmvc_controller.rb')
class Index < Titania::System::XMVC::XMVCController


  def index(client, args=nil)
    client.writeHead(200, {
        'Content-type' => 'text/html'
    })
    @title = "Titania Framework"
    client.write(@view.load('index.html', {
        "title" => "Titania Framework",
        "content" => "
        Titania framework is a lorem"
    }))
    client.end()
  end
end