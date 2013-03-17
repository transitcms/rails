class @Transit.Model extends Spine.Model
  @configure 'Model', '_type'
  @hasMany 'attachments', 'Attachment'


class Attachment extends Spine.Model
  @configure 'Attachment', 'model', 'file', 'param'