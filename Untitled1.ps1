$mBox =  [Windows.Forms.MessageBox]::Show("message", "title", [Windows.Forms.MessageBoxButtons]::YesNoCancel, [Windows.Forms.MessageBoxIcon]::Question)

if( $mBox -eq [System.Windows.Forms.DialogResult]::YES ) { }
if( $mBox -eq [System.Windows.Forms.DialogResult]::NO ) {"You clicked No" }
 else { }