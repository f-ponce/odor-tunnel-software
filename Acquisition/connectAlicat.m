function varargout=connectAlicat(aliComm)
% function aliComm=connectAlicat(aliComm)
%
% Form a connection to the Alicat controller. If an argument is given then
% the connection to the specified device is closed.
%
%
% Rob Campbell - 20th March 2008 - CSHL


if nargin==0
    % %disconnecting existing serial port connections
    % existing_serialports = serialportfind;
    % delete(existing_serialports);

    global aliComm

%     aliComm=serial('COM3',... %%RTM EDIT from COM4
%         'TimeOut', 2,...
%         'BaudRate', 19200,...
%         'Terminator','CR');
    available_serialport=serialportlist;
    aliComm=serialport(available_serialport, 19200, "Timeout",2);
    configureTerminator(aliComm, "CR")

    fopen(aliComm)
    varargout{1}=aliComm;

elseif nargin==1
    fclose(aliComm)
    delete(aliComm)
    clear global aliComm
end
