if (exist('Camera'))
    Camera.Close();
end
close all
clear 

Basler_Camera=NET.addAssembly([pwd '\Basler_DotNet\Basler.Pylon.dll']);
Camera_Find=Basler.Pylon.CameraFinder.Enumerate();
Camera_Select=Camera_Find.Item(0);
Camera=Basler.Pylon.Camera(Camera_Select);
Camera.Open();


PATH_CameraDevice=Basler.Pylon.ParameterPath.CameraDevice;
PATH_CameraInstance=Basler.Pylon.ParameterPath.CameraInstance;
PATH_DeviceTransportLayer=Basler.Pylon.ParameterPath.DeviceTransportLayer;
PATH_EventGrabber=Basler.Pylon.ParameterPath.EventGrabber;
PATH_StreamGrabber0=Basler.Pylon.ParameterPath.StreamGrabber0;

Camera_Parameters=Camera.Parameters;
Camera_Parameters.Refresh();

Camera_Parameters_MaxNumBuffer=Camera_Parameters.Item('@CameraInstance/MaxNumBuffer');
Camera_Parameters_PixelFormat=Camera_Parameters.Item('@CameraDevice/PixelFormat');
Camera_Parameters_AutoFunctionROISelector =Camera_Parameters.Item('@CameraDevice/AutoFunctionROISelector');
Camera_Parameters_AutoFunctionROISelectorOffsetX = Camera_Parameters.Item('@CameraDevice/AutoFunctionROIOffsetX');
Camera_Parameters_AutoFunctionROISelectorOffsetY = Camera_Parameters.Item('@CameraDevice/AutoFunctionROIOffsetY');
Camera_Parameters_AutoFunctionROISelectorWidth = Camera_Parameters.Item('@CameraDevice/AutoFunctionROIWidth');
Camera_Parameters_AutoFunctionROISelectorHeight = Camera_Parameters.Item('@CameraDevice/AutoFunctionROIHeight');
Camera_Parameters_ExposureAuto =Camera_Parameters.Item('@CameraDevice/ExposureAuto');
Camera_Parameters_ExposureTimeRaw =Camera_Parameters.Item('@CameraDevice/ExposureTimeRaw');
Camera_Parameters_GainAuto =Camera_Parameters.Item('@CameraDevice/GainAuto');
Camera_Parameters_GainRaw = Camera_Parameters.Item('@CameraDevice/GainRaw');

Camera_Parameters_MaxNumBuffer.ParseAndSetValue('100');
Camera_Parameters_PixelFormat.ParseAndSetValue('RGB8');
Camera_Parameters_GainAuto.ParseAndSetValue('Off');
Camera_Parameters_GainRaw.ParseAndSetValue('15');
Camera_Parameters_ExposureAuto.ParseAndSetValue('Off');
Camera_Parameters_ExposureTimeRaw.ParseAndSetValue('10000');

Camera_Parameters.Save([pwd '\Parameters_CameraDevice.txt'],PATH_CameraDevice);
Camera_Parameters.Save([pwd '\Parameters_CameraInstance.txt'],PATH_CameraInstance);
Camera_Parameters.Save([pwd '\Parameters_DeviceTransportLayer.txt'],PATH_DeviceTransportLayer);
Camera_Parameters.Save([pwd '\Parameters_EventGrabber.txt'],PATH_EventGrabber);
Camera_Parameters.Save([pwd '\Parameters_StreamGrabber0.txt'],PATH_StreamGrabber0);

COUNT_OF_IMAGE_TO_GRAB=1;
% VEDIO_FILE_NAME=[pwd '\test.mp4'];
%
% VideoWriter=Basler.Pylon.VideoWriter;
% VideoWriter_Parameters=VideoWriter.Parameters;

% VideoWriter.Create(VEDIO_FILE_NAME,25,Camera);
for i=8:1:24
    for k=50000:50000:1000000
        Camera_Parameters_GainRaw.ParseAndSetValue(num2str(i));
        Camera_Parameters_ExposureTimeRaw.ParseAndSetValue(num2str(k));
        Camera_StreamGrabber=Camera.StreamGrabber;
        Camera_StreamGrabber.Start(COUNT_OF_IMAGE_TO_GRAB);
        while (Camera_StreamGrabber.IsGrabbing)
            Camera_GrabResults=Camera_StreamGrabber.RetrieveResult(5000,Basler.Pylon.TimeoutHandling.ThrowException);
            if (Camera_GrabResults.GrabSucceeded)
                %         Camera_Data=Camera_GrabResults.PixelData;
                %         Display_Window=Basler.Pylon.ImageWindow;
                %         Display_Window.DisplayImage(0,Camera_GrabResults);
                %         Camera_Data_int8=Camera_Data.uint8;
                %         reshape_value=reshape(Camera_Data_int8,[3,5038848]);
                %         Camera_Data_R=reshape(reshape_value(1,:),[2592,1944])';
                %         Camera_Data_G=reshape(reshape_value(2,:),[2592,1944])';
                %         Camera_Data_B=reshape(reshape_value(3,:),[2592,1944])';
                %         C(:,:,1)=Camera_Data_R;
                %         C(:,:,2)=Camera_Data_G;
                %         C(:,:,3)=Camera_Data_B;
                %         imshow(C);
                Basler.Pylon.ImagePersistence.Save(Basler.Pylon.ImageFileFormat.Jpeg,[pwd '\Results\Gain_' num2str(i) '_Exp_' num2str(k/1000) 'ms.jpg'],Camera_GrabResults);
                %         VideoWriter.Write(Camera_GrabResults);
            end
        end
        % VideoWriter.Close();
        Camera_StreamGrabber.Stop();
        % vvv.string;
    end
end

Camera.Dispose();
Camera.Close();

